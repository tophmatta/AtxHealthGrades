//
//  SearchViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation
import SwiftUICore

@MainActor
@Observable class SearchViewModel {
    let client: ISocrataClient

    var error: Error? = nil
    var currentReports = [Report]()
    
    init(_ client: ISocrataClient) {
        self.client = client
    }

    func clear() {
        currentReports = [Report]()
    }
    
    func triggerSearch(value: String) async {
        do {
            currentReports = try await client.search(byName: value).filterOldDuplicates()
        } catch let searchError {
            error = searchError
        }
    }
}
