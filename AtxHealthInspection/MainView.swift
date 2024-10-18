//
//  MainView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI

struct MainView: View {
    init() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = UIColor.green
        tabBarAppearance.backgroundColor = UIColor(Color("tabBarBackground"))
    }

    @StateObject var searchViewModel = SearchViewModel(SocrataAPIClient())
    @StateObject var mapViewModel = MapViewModel(SocrataAPIClient(), locationModel: LocationModel())

    var body: some View {
        TabView {
            SearchView()
                .environmentObject(searchViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            MapView()
                .environmentObject(mapViewModel)
                .tabItem { Label("Map", systemImage: "map") }
        }
        .tint(Color.green)
    }
}

#Preview {
    MainView()
}
