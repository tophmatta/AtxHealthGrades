//
//  MainView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI

enum Tab {
    case search, map
}

struct MainView: View {
    @StateObject private var searchViewModel: SearchViewModel
    @StateObject private var mapViewModel: MapViewModel
    
    @State private var selectedTab: Tab = .search
    
    init(client: ISocrataClient = SocrataAPIClient()) {
        _searchViewModel = StateObject(wrappedValue: SearchViewModel(client))
        _mapViewModel = StateObject(wrappedValue: MapViewModel(client))
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = UIColor.green
        tabBarAppearance.backgroundColor = UIColor(Color("tabBarBackground"))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView($selectedTab)
                .environmentObject(searchViewModel)
                .environmentObject(mapViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            MapView()
                .environmentObject(mapViewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(Tab.map)
        }
        .tint(Color.green)
    }
}

#Preview {
    MainView()
}
