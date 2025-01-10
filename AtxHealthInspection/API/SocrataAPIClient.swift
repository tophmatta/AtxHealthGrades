//
//  SocrataAPIClient.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/7/24.
//

import Foundation
import CoreLocation

protocol SocrataClientProtocol: Sendable {
    func search(byName value: String) async throws -> [Report]
    func search(inRadiusOf location: CLLocationCoordinate2D) async throws -> [Report]
    func getReports(forRestaurantWith facilityId: String) async throws -> [Report]
}

struct SocrataAPIClient: SocrataClientProtocol {
    
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func search(byName value: String) async throws -> [Report] {
        let str = value.trimForQuery()
        
        guard str.isNotEmpty else { throw ClientError.emptyInputValue }
        
        let query = "lower(restaurant_name) like '%\(str)%'"
        
        do {
            return try await get(query)
        } catch ClientError.emptyResponse {
            throw ClientError.emptyTextSearchResponse
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
        else { throw ClientError.invalidUrl }
                
        do {
            return try await client.get(url, forType: [Report].self)
        } catch {
            throw error
        }
    }
    
    func search(inRadiusOf location: CLLocationCoordinate2D) async throws -> [Report] {
        guard location.isValid() else { throw ClientError.invalidLocation }
        
        let query = "within_circle(address, \(location.latitude), \(location.longitude), \(Constants.Distance.oneMileInMeters))"
        do {
            return try await get(query)
        } catch ClientError.emptyResponse {
            throw ClientError.emptyProximitySearchResponse
        } catch {
            throw error
        }
    }
    
    func getReports(forRestaurantWith facilityId: String) async throws -> [Report] {
        let query = "facility_id=" + facilityId
        
        do {
            return try await get(query)
        } catch {
            throw error
        }
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
