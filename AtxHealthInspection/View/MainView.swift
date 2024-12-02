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
    @State private var mapViewModel: MapViewModel
    @State private var favoritesViewModel: FavoritesViewModel
    
    @State private var selectedTab: Tab = .search
    
    init(client: ISocrataClient = SocrataAPIClient()) {
        _searchViewModel = State(wrappedValue: SearchViewModel(client))
        _mapViewModel = State(wrappedValue: MapViewModel(client))
        _favoritesViewModel = State(wrappedValue: FavoritesViewModel())
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = .green
        tabBarAppearance.backgroundColor = .surface
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapView()
                .environment(mapViewModel)
                .environment(searchViewModel)
                .environment(favoritesViewModel)
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
