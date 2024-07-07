//
//  SearchViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation


public enum FilterType: String, CaseIterable, Identifiable {
    case Name, ZipCode = "Zip Code"
    public var id: Self { self }
}

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var filterType: FilterType = .Name
    @Published var error: SearchError? = nil
    @Published var currReport: Report? = nil
    
    func triggerSearch(value: String) {
        Task {
            let result = await searchByName(value)
            
            switch result {
            case .success(let reportResult):
                currReport = reportResult
                print(reportResult.description)
                
            case .failure(let errorResult):
                error = errorResult
                print(error!.localizedDescription)
            }
        }
    }
    
    private func searchByName(_ value: String) async -> Result<Report, SearchError> {
        return await Task.detached(priority: .background) { [weak self] in
            guard value.isNotEmpty, let self else { return .failure(.emtpyValue) }
            
            var searchName = prepareForRequest(value)
            
            // Lowercase the column to match param
            let query = "lower(restaurant_name) like '%\(searchName)%'"
            
            guard
                let url = RequestBuilder
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
    
    nonisolated private func prepareForRequest(_ value: String) -> String {
        var result = value
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .map { substring -> String in
                let str = String(substring)
                // Must use unicode value for apostrophe
                return str.hasSuffix("\u{2019}s") ? String(str.dropLast(2)) : str
            }
            .joined(separator: " ")

        if result.hasPrefix("the ") {
            result.removeFirst(4)
        }
        
        return result
    }
}

enum SearchError: Error {
    case invalidUrl, decodingError, emtpyValue
}
