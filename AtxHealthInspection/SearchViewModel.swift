//
//  SearchViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import Foundation


class SearchViewModel: ObservableObject {
    
    func makeRequest() async -> Report? {
        guard
            var url = URL(string: Constants.endpoint)
        else { return nil }
        
        //TODO 
        url = url.appending(queryItems: [URLQueryItem(name: "$where", value: "score>90")])

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode([Report].self, from: data)
            
            return result.first!
        } catch {
            print("Error with request")
        }
        return nil
    }


}
