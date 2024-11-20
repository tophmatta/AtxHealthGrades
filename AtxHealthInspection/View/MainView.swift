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
    @State private var searchViewModel: SearchViewModel
    @StateObject private var mapViewModel: MapViewModel
    @StateObject private var favoritesViewModel: FavoritesViewModel
    
    @State private var selectedTab: Tab = .search
    
    init(client: ISocrataClient = SocrataAPIClient()) {
        _searchViewModel = State(wrappedValue: SearchViewModel(client))
        _mapViewModel = StateObject(wrappedValue: MapViewModel(client))
        _favoritesViewModel = StateObject(wrappedValue: FavoritesViewModel())
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = .green
        tabBarAppearance.backgroundColor = .surface
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView($selectedTab)
                .environment(searchViewModel)
                .environmentObject(mapViewModel)
                .environmentObject(favoritesViewModel)
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
