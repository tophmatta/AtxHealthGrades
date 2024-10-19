//
//  SocrataAPIClient.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/7/24.
//

import Foundation
import CoreLocation

protocol ISocrataClient: Sendable {
    func searchByName(_ value: String) async throws -> [Report]
}

struct SocrataAPIClient: ISocrataClient {
    
    let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func searchByName(_ value: String) async throws -> [Report] {
        try await Task(priority: .background) {
            let str = value.trimForQuery()
            
            guard str.isNotEmpty else { throw ClientError.emptyValue }
            
            let query = "lower(restaurant_name) like '%\(str)%'"
            let result: [Report]
            
            do {
                result = try await get(query)
            } catch {
                throw error
            }
            
            return result
        }.value
    }
    
    private func get(_ rawQuery: String) async throws -> [Report] {
        guard
            let url =
            UrlBuilder
                .create()
                .addQuery(rawQuery)
                .build()
        else { throw ClientError.invalidUrl }
        
        let result: [Report]
        
        do {
            result = try await client.get(url, forType: [Report].self)
            
            guard !result.isEmpty else {
                throw ClientError.emptyResponse
            }
        } catch {
            throw error
        }
        return result
    }
    
    func searchByLocation(_ location: CLLocationCoordinate2D) async throws -> Report? {
        guard location.isValid() else { throw ClientError.invalidLocation }
        
        let query = "within_circle(null, \(location.latitude), \(location.longitude), 1000)"
        return try! await get(query).first
    }
}

extension String {
    func trimForQuery() -> Self {
        return self
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "^the ", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\u{2019}s", with: "")
            .replacingOccurrences(of: "'s", with: "")
    }
}
