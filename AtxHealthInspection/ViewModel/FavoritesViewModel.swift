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
    private let manager: FavoritesManager
    
    init(_ manager: FavoritesManager = FavoritesManager()) {
        self.manager = manager
        
        Task {
            favoritesNames = await Set(manager.getValues().values)
        }
    }
    
    func toggleFavorite(report: Report) async {
        await manager.toggleValue(report: report)
        favoritesNames = await Set(manager.getValues().values)
    }
    
    func isFavorite(_ report: Report) async -> Bool {
        favoritesNames.contains(report.restaurantName)
    }
    
}
