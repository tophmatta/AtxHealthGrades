//
//  MainView.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI

enum TabType {
    case map, favorites
}

struct MainView: View {
    @State private var searchViewModel: SearchViewModel
    @State private var mapViewModel: MapViewModel
    @State private var favoritesViewModel: FavoritesViewModel
    
    @State private var selectedTab: TabType = .map
    @State private var poiSelected: LocationReportGroup?
    
    init(client: SocrataClientProtocol = SocrataAPIClient()) {
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
            MapView(poiSelected: $poiSelected)
                .environment(mapViewModel)
                .environment(searchViewModel)
                .environment(favoritesViewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(TabType.map)
            FavoritesView(selectedTab: $selectedTab, poiSelected: $poiSelected)
                .environment(favoritesViewModel)
                .environment(mapViewModel)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .tag(TabType.favorites)
        }
        .tint(Color.green)
    }
}

#Preview {
    MainView()
}
