//
//  SearchViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    let client: ISocrataClient

    @Published var error: Error? = nil
    @Published var currentReports = [Report]()
    
    init(_ client: ISocrataClient) {
        self.client = client
    }

    func triggerSearch(value: String) async {
        do {
            currentReports = try await client.searchByName(value).filterOldDuplicates()
        } catch let searchError {
            error = searchError
        }
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
