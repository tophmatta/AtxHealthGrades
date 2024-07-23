//
//  SocrataClient.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/7/24.
//

import Foundation
import CoreLocation

protocol ISocrataClient {
    func searchByName(_ value: String) async throws -> [Report]
    func prepareForRequest(_ value: String) -> String
}

enum SearchError: Error {
    case invalidUrl, decodingError, emptyValue, invalidLocation, invalidResponse, networkError
}

struct SocrataClient: ISocrataClient {
    func searchByName(_ value: String) async throws -> [Report] {
        guard value.isNotEmpty else { throw SearchError.emptyValue }
        
        let searchName = prepareForRequest(value)
        
        // Lowercase the column to match param
        let query = "lower(restaurant_name) like '%\(searchName)%'"
        
        let result: [Report]
        do {
            result = try await get(query)
        } catch {
            throw error
        }
        return result
    }
    
    private func get(_ rawQuery: String) async throws -> [Report] {
        try await Task(priority: .background) {
            guard
                let url =
                UrlBuilder
                    .create()
                    .addQuery(rawQuery)
                    .build()
            else { throw SearchError.invalidUrl }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw SearchError.invalidResponse
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode([Report].self, from: data)
            } catch DecodingError.dataCorrupted(_),
                    DecodingError.keyNotFound(_, _),
                    DecodingError.typeMismatch(_, _),
                    DecodingError.valueNotFound(_, _) {
                throw SearchError.decodingError
            } catch {
                throw SearchError.networkError
            }
        }.value
    }
    
    func searchByLocation(_ location: CLLocationCoordinate2D) async throws -> Report? {
        guard location.isValid() else { throw SearchError.invalidLocation }
        
        let query = "within_circle(null, \(location.latitude), \(location.longitude), 1000)"
        return try! await get(query).first
    }
    
    nonisolated func prepareForRequest(_ value: String) -> String {
        return value
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "^the ", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\u{2019}s", with: "")
            .replacingOccurrences(of: "'s", with: "")
    }
}
