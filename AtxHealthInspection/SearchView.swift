//
//  SearchView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    func makeRequest() async -> Report? {
        guard
            var url = URL(string: Constants.endpoint)
        else { return nil }
        
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

#Preview {
    SearchView()
}
