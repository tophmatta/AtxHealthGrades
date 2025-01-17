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
        ZStack {
            VStack {
                Text("Favorites")
                    .font(.title)
                List {
                    ForEach(viewModel.favorites) {
                        Text($0.name)
                    }
                    .onDelete(perform: viewModel.onDelete)
                }
            }
            if viewModel.favorites.count == 0 {
                Text("To add a favorite, tap the \"\u{2605}\" for a restaurant")
                    .fontWeight(.light)
                    .font(.title2)
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environment(FavoritesViewModel(useMock: false))
}

