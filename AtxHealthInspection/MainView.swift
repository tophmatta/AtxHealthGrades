//
//  MainView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    init() {
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = UIColor.green
        tabBarAppearance.backgroundColor = UIColor(Color("tabBarBackground"))
    }
    
    @StateObject var viewModel: SearchViewModel = SearchViewModel(SocrataClient())

    var body: some View {
        TabView {
            SearchView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            MapView()
                .tabItem { Label("Map", systemImage: "map") }
        }
        .tint(Color.green)
    }
}


#Preview {
    MainView()
}
