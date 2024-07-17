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
    case invalidUrl, decodingError, emptyValue, invalidLocation
}

struct SocrataClient: ISocrataClient {
    func searchByName(_ value: String) async throws -> [Report] {
        guard value.isNotEmpty else { throw SearchError.emptyValue }
        
        let searchName = prepareForRequest(value)
        
        // Lowercase the column to match param
        let query = "lower(restaurant_name) like '%\(searchName)%'"
        return try! await get(query)
    }
    
    private func get(_ rawQuery: String) async throws -> [Report] {
        try! await Task(priority: .background) {
            guard
                let url =
                UrlBuilder
                    .create()
                    .addQuery(rawQuery)
                    .build()
            else { throw SearchError.invalidUrl }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                            
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode([Report].self, from: data)
            } catch {
                throw SearchError.decodingError
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
