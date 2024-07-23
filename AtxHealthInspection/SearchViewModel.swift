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
    - design cell: show address, score, last inspection date, maybe a picture of the front
    - perhaps collapsable cells
    - show on map button
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
    @Published var currentReport: Report? = nil
    
    init(_ client: ISocrataClient) {
        self.client = client
    }

    func triggerSearch(value: String) {
        Task {
            do {
                let reports = try await client.searchByName(value)
                currentReport = reports.sorted { $0.date > $1.date }.first
            } catch let searchError {
                error = searchError
                print(error?.localizedDescription ?? "No error description")
            }
        }
    }
    
    func clearResult() {
        currentReport = nil
    }
    
    func clearError() {
        error = nil
    }
}
