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
    func searchByLocation(_ location: CLLocationCoordinate2D) async throws -> [Report]
}

struct SocrataAPIClient: ISocrataClient {
    
    let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func searchByName(_ value: String) async throws -> [Report] {
        let str = value.trimForQuery()
        
        guard str.isNotEmpty else { throw ClientError.emptyValue }
        
        let query = "lower(restaurant_name) like '%\(str)%'"
        
        do {
            return try await get(query)
        } catch {
            throw error
        }
    }
    
    private func get(_ rawQuery: String) async throws -> [Report] {
        guard
            let url =
            UrlBuilder
                .create()
                .addQuery(rawQuery)
                .build()
        else {
            throw ClientError.invalidUrl
        }
                
        do {
            let result = try await client.get(url, forType: [Report].self)
            
            guard !result.isEmpty else {
                throw ClientError.emptyResponse
            }
            
            return result
        } catch {
            throw error
        }
    }
    
    func searchByLocation(_ location: CLLocationCoordinate2D) async throws -> [Report] {
        guard location.isValid() else { throw ClientError.invalidLocation }
        
        let query = "within_circle(address, \(location.latitude), \(location.longitude), \(oneMileInMeters))"
        do {
            return try await get(query)
        } catch {
            throw error
        }
    }
    
    private let oneMileInMeters = 1609
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
