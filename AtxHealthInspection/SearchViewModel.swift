//
//  SearchViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation

public enum SearchType: String, CaseIterable, Identifiable {
    case Name, ZipCode = "Zip Code"
    public var id: Self { self }
}

/*
 TODO:
 - testing response decoding
 - testing api requests
 - onSearchTypeChanged
 - show modal for errors
 - show list of results
    - design cell: show address, score, last inspection date
    - perhaps collapsable cells
    - show on map button - all or specific result
 - Show look around view when tap on result on map
 - show look around view if user taps specific result from list
 - map search feature - search within a X mile radius
 */

@MainActor
protocol ISearchViewModel {
    var client: ISocrataClient { get }
    // TODO: -
}

@MainActor
class SearchViewModel: ObservableObject, ISearchViewModel {
    let client: ISocrataClient

    @Published var searchType: SearchType = .Name
    @Published var error: Error? = nil
    @Published var currentReports = [Report]()
    
    init(_ client: ISocrataClient) {
        self.client = client
    }

    func triggerSearch(value: String) {
        Task {
            do {
                currentReports = try await client.searchByName(value).filterOldDuplicates()
            } catch let searchError {
                error = searchError
                print(error?.localizedDescription ?? "No error description")
            }
        }
    }
        
    func clearResult() {
        currentReports = [Report]()
    }
    
    func clearError() {
        error = nil
    }
}

private extension Collection where Element == Report {
    func filterOldDuplicates() -> [Report] {
        var seen = Set<Report>()
        
        let filterNewest = self.sorted { $0.date > $1.date }.filter { report in
            if seen.contains(report) {
                return false
            } else {
                seen.insert(report)
                return true
            }
        }
        
        return filterNewest
    }
}
