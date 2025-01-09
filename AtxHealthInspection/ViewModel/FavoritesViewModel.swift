//
//  FavoritesViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/18/24.
//

import SwiftUI

@MainActor
@Observable final class FavoritesViewModel {
    var favoritesNames: Set<String> = []
    private let store: FavoritesStore
    
    init(_ store: FavoritesStore = FavoritesStore()) {
        self.store = store
        
        Task {
            favoritesNames = await Set(store.getValues().values)
        }
    }
    
    func toggleFavorite(report: Report) async {
        await store.toggleValue(report: report)
        favoritesNames = await Set(store.getValues().values)
    }
    
    func isFavorite(_ report: Report) async -> Bool {
        favoritesNames.contains(report.restaurantName)
    }
    
}
