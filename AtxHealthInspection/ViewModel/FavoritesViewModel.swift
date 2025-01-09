//
//  FavoritesViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/18/24.
//

import SwiftUI
import OrderedCollections

@MainActor
@Observable final class FavoritesViewModel {
    var favorites: [FavoriteData] = []
    private let store: FavoritesStore
    
    init(_ store: FavoritesStore = FavoritesStore(), useMock: Bool = false) {
        self.store = store
        
        if useMock {
            favorites = mockData
        } else {
            Task {
                favorites = await getFavorites()
            }
        }
    }
    
    func toggleFavorite(report: Report) async {
        await store.toggleValue(report: report)
        favorites = await getFavorites()
    }
    
    func isFavorite(_ report: Report) async -> Bool {
        favorites.contains { $0.name == report.restaurantName }
    }
    
    func getFavorites() async -> [FavoriteData] {
        await store.getValues().map { FavoriteData(id: $0.key, name: $0.value) }
    }
    
    func onDelete(at offsets: IndexSet) {
        guard
            offsets.first == offsets.last,
            let index = offsets.first
        else { return }
        
        Task {
            let id = favorites[index].id
            await store.remove(by: id)
            favorites = await getFavorites()
        }
    }
}

struct FavoriteData: Identifiable {
    let id: String
    let name: String
}

#if DEBUG
extension FavoritesViewModel {
    private var mockData: [FavoriteData] {
        [
            FavoriteData(id: "1", name: "Tony's Donuts"),
            FavoriteData(id: "2", name: "Chelsea's Crepes"),
            FavoriteData(id: "3", name: "Elaines Bagels"),
            FavoriteData(id: "4", name: "Mama's Fried Chicken")
        ]
    }
}
#endif
