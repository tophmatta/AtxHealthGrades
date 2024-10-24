//
//  SearchViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation


/*
 TODO:
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
class SearchViewModel: ObservableObject {
    let client: ISocrataClient

    @Published var error: Error? = nil
    @Published var currentReports = [Report]()
    
    init(_ client: ISocrataClient) {
        self.client = client
    }

    nonisolated func triggerSearch(value: String) {
        Task {
            do {
                let result = try await client.searchByName(value).filterOldDuplicates()
                Task { @MainActor in
                    currentReports = result
                }
            } catch let searchError {
                Task { @MainActor in
                    error = searchError
                }
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
