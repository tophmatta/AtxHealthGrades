//
//  SocrataClient.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/7/24.
//

import Foundation


protocol ISocrataClient {
    func get(_ value: String) async -> Result<Report, SearchError>
}

enum SearchError: Error {
    case invalidUrl, decodingError, emtpyValue
}

struct SocrataClient: ISocrataClient {
    
    func get(_ value: String) async -> Result<Report, SearchError> {
        return await Task.detached(priority: .background) {
            guard value.isNotEmpty else { return .failure(.emtpyValue) }
            
            let searchName = prepareForRequest(value)
            
            // Lowercase the column to match param
            let query = "lower(restaurant_name) like '%\(searchName)%'"
            
            guard
                let url = UrlBuilder
                            .create()
                            .addQuery(query)
                            .build()
            else { return .failure(.invalidUrl) }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                            
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([Report].self, from: data)
                
                guard !result.isEmpty else { return .failure(.decodingError) }
                
                return .success(result.first!)
            } catch {
                return .failure(.decodingError)
            }
        }.value
    }
}

private extension SocrataClient {
    nonisolated private func prepareForRequest(_ value: String) -> String {
        return value
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { substring -> String in
                let str = String(substring)
                // Must use unicode value for apostrophe
                return str.hasSuffix("\u{2019}s") ? String(str.dropLast(2)) : str
            }
            .joined(separator: " ")
            .replacingOccurrences(of: "^the ", with: "", options: .regularExpression)
    }
}
