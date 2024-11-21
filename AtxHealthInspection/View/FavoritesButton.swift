//
//  FavoritesButton.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/15/24.
//

import SwiftUI

struct FavoriteButton: View {
    @Environment(FavoritesViewModel.self) var favoritesViewModel: FavoritesViewModel
    let id: String
    
    var body: some View {
        Button {
            favoritesViewModel.toggleFavorite(id: id)
        } label: {
            Label("Toggle Favorite", systemImage: isSet(id) ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet(id) ? .green : .gray)
                .contentShape(Rectangle()) // makes only the button (not row) tappable
        }
        .buttonStyle(PlainButtonStyle()) // makes only the button (not row) tappable
    }
    
    private func isSet(_ id: String) -> Bool {
        favoritesViewModel.isFavorite(id)
    }
}
