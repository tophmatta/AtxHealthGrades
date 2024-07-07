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
 - testing string preparing
 - onSearchTypeChanged
 */

@MainActor
protocol ISearchViewModel {
    var client: ISocrataClient { get }
    //TODO: -
}

@MainActor
class SearchViewModel: ObservableObject, ISearchViewModel {
    let client: ISocrataClient
    
    @Published var searchType: SearchType = .Name
    @Published var error: SearchError? = nil
    @Published var currReport: Report? = nil
    
    init(_ client: ISocrataClient) {
        self.client = client
    }
    
    func triggerSearch(value: String) {
        Task {
            let result = await client.get(value)
            
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
    
    func onSearchTypeChanged() {
        //TODO: -
    }
}
