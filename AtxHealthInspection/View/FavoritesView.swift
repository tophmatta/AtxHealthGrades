//
//  FavoritesView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 12/31/24.
//
import SwiftUI

struct FavoritesView: View {
    @Environment(FavoritesViewModel.self) var viewModel
    
    var body: some View {
        Text("Favorites")
            .font(.headline)
    }
}

