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
    }
}

#Preview {
    FavoritesView()
        .environment(FavoritesViewModel(useMock: true))
}

