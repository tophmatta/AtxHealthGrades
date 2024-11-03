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
