//
//  FavoritesViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/18/24.
//

import SwiftUI

@MainActor
@Observable final class FavoritesViewModel {
    var favorites: [FavoriteData] = []
    private let store: FavoritesStore
    
    init(_ store: FavoritesStore = FavoritesStore()) {
        self.store = store
        
        Task {
            favorites = await getFavorites()
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
