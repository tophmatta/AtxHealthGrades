//
//  FavoritesView.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 12/31/24.
//
import SwiftUI

struct FavoritesView: View {
    @Environment(FavoritesViewModel.self) var favoritesViewModel
    @Environment(MapViewModel.self) var mapViewModel
    @Binding var selectedTab: TabType
    @Binding var poiSelected: LocationReportGroup?
    
    var body: some View {
        ZStack {
            VStack {
                Text("Favorites")
                    .font(.title)
                List {
                    ForEach(favoritesViewModel.favorites) { favorite in
                        Button {
                            Task {
                                // Force the poi to display on the map
                                if let latest = await mapViewModel.getAllReports(with: favorite.id).first,
                                    let poiData = latest.toPoiData() {
                                    selectedTab = .map
                                    mapViewModel.updatePOIs(poiData)
                                    poiSelected = poiData.values.first
                                }
                            }
                        } label: {
                            HStack {
                                Text(favorite.name)
                                    .font(.title2)
                                    .foregroundStyle(.onSurface)
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                Image(systemName: "chevron.forward.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                            }
                            .frame(height: 40)
                        }
                    }
                    .onDelete(perform: favoritesViewModel.onDelete)
                }
            }
            if favoritesViewModel.favorites.count == 0 {
                Text("To add a favorite, tap the \"\u{2605}\" for a restaurant")
                    .fontWeight(.light)
                    .font(.title2)
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
    }
}
