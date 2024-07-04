//
//  MainView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @StateObject var viewModel: SearchViewModel = SearchViewModel()

    var body: some View {
        TabView {
            SearchView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            //TODO: Mapview
        }
    }

    
}


//#Preview {
//    MainView()
//}
