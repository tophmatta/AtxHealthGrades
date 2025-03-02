//
//  SocrataAPIClient.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/7/24.
//

import Foundation
import CoreLocation

protocol SocrataClientProtocol: Sendable {
    func getReports(byName value: String) async throws -> [Report]
    func getReports(inRadiusOf location: CLLocationCoordinate2D) async throws -> [Report]
    func getReports(forRestaurantWith facilityId: String) async throws -> [Report]
}

struct SocrataAPIClient: SocrataClientProtocol {
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func getReports(byName value: String) async throws -> [Report] {
        let str = value.prepForQuery()
        
        guard str.isNotEmpty else {
            throw ClientError.emptyInputValue
        }
        
        let query = "lower(restaurant_name) like '%\(str)%'"
        
        do {
            return try await get(via: query)
        } catch ClientError.emptyResponse {
            throw ClientError.emptyTextSearchResponse
        } catch {
            throw error
        }
    }
        
    func getReports(inRadiusOf location: CLLocationCoordinate2D) async throws -> [Report] {        
        guard location.isInAustin() else {
            throw ClientError.notInBounds
        }

        guard location.isValid() else {
            throw ClientError.invalidLocation
        }
        
        let query = "within_circle(address, \(location.latitude), \(location.longitude), \(Constants.Distance.oneMileInMeters))"
        
        do {
            return try await get(via: query)
        } catch ClientError.emptyResponse {
            throw ClientError.emptyProximitySearchResponse
        } catch {
            throw error
        }
    }
    
    func getReports(forRestaurantWith facilityId: String) async throws -> [Report] {
        let query = "facility_id=" + facilityId
        
        do {
            return try await get(via: query)
        } catch {
            throw error
        }
    }
    
    private func get(via rawQuery: String) async throws -> [Report] {
        guard let url = UrlBuilder
                            .create()
                            .addQuery(rawQuery)
                            .build()
        else {
            throw ClientError.invalidUrl
        }
                
        do {
            let results = try await client.get(url, forType: [Report].self)
            
            guard !results.isEmpty else {
                throw ClientError.emptyResponse
            }
            
            return results
        } catch {
            throw error
        }
    }
}

extension String {
    func prepForQuery() -> Self {
        return self
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "^the\\s+", with: "", options: .regularExpression) // Remove "the " at the start
            .replacingOccurrences(of: "[’']s", with: "", options: .regularExpression) // Remove 's and ’s
            .replacingOccurrences(of: "[^a-z0-9\\s]", with: "", options: .regularExpression) // Remove special characters/punctuation
            .replacingOccurrences(of: "(?<![aeiou])s$", with: "", options: .regularExpression) // Remove s if consonant preceeds it
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression) // Collapse multiple spaces into one
            .replacingOccurrences(of: " ", with: "%") // Use wildcard for better searchability with SQL-like API
    }
}
