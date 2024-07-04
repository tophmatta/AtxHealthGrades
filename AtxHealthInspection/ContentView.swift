//
//  ContentView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var report: Report

    var body: some View {
        VStack {
            Text(report.restaurantName)
            Text(report.score)
        }
            .task {
                guard let data = await makeRequest() else { return }
                report = data
            }
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

struct Report: Decodable {
    let restaurantName: String
    let score: String

}

extension Report: CustomStringConvertible {
    var description: String {
        return "name: \(restaurantName), score: \(score)"
    }
    
    static var empty: Report {
        return Report(restaurantName: "N/A", score: "N/A")
    }
}

//#Preview {
//    ContentView()
//}
