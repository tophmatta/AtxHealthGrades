//
//  APIClient.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 8/25/24.
//

import Foundation

protocol APIClientProtocol: Sendable {
    func get<T: Decodable>(_ url: URL, forType type: T.Type) async throws -> T
}

struct APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get<T: Decodable>(_ url: URL, forType type: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ClientError.invalidResponse
            }
            
            guard !data.isEmpty else {
                throw ClientError.emptyResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(type, from: data)
        } catch is DecodingError {
            throw ClientError.decodingError
        } catch {
            throw error
        }
    }
}
