//
//  FavoritesButton.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 11/15/24.
//

import SwiftUI

struct FavoriteButton: View {
    @Environment(FavoritesViewModel.self) var favoritesViewModel
    @State private var isFavorite: Bool = false
    let report: Report
    
    var body: some View {
        Button {
            Task {
                await favoritesViewModel.toggleFavorite(report: report)
                isFavorite = await favoritesViewModel.isFavorite(report)
            }
        } label: {
            Label("Toggle Favorite", systemImage: isFavorite ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isFavorite ? .green : .gray)
                .contentShape(Rectangle()) // makes only the button (not row) tappable
        }
        .buttonStyle(PlainButtonStyle()) // makes only the button (not row) tappable
        .task {
            isFavorite = await favoritesViewModel.isFavorite(report)
        }
    }
}
