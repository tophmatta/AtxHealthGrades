//
//  SearchView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(SearchViewModel.self) var searchViewModel: SearchViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
    @Binding var selectedTab: Tab
    @State private var searchText: String = ""
    
    @FocusState private var isFocused: Bool
    
    init(_ selectedTab: Binding<Tab>) {
        _selectedTab = selectedTab
        UITextField.appearance().clearButtonMode = .always
    }
    
    var body: some View {
        @Bindable var bindableSearchViewModel = searchViewModel
        
        ZStack {
            FoodBackground()
                .ignoresSafeArea(edges: [.top, .leading, .trailing])
                .dismissKeyboardOnTap()
            VStack(alignment: .center, spacing: 15.0) {
                Logo()
                SearchBar()
                SearchButton()
            }
            .offset(y: -80)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $bindableSearchViewModel.currentReports.isNotEmpty()) {
            ReportList(searchViewModel.currentReports, selectedTab: $selectedTab)
                .presentationDetents([.medium, .large])
                .presentationCompactAdaptation(.none)
        }
        .alert(
            "Something went wrong...",
            isPresented: $bindableSearchViewModel.error.isNotNil(),
            presenting: searchViewModel.error,
            actions: { _ in },
            message: { error in
                Text(error.localizedDescription).padding(.top, 15)
            }
        )
    }
    
    func SearchBar() -> some View {
        TextField("Enter a Restaurant Name", text: $searchText)
            .padding()
            .background(.surface)
            .clipShape(
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
            )
            .padding([.leading, .trailing], 10.0)
            .shadow(color: .gray, radius: 5.0)
            .foregroundStyle(.onSurface)
            .focused($isFocused)
    }
    
    func SearchButton() -> some View {
        Button {
            Task {
                await searchViewModel.triggerSearch(value: searchText)
                isFocused = false
            }
        } label: {
            Text("Search")
                .font(.title2)
                .bold()
        }
        .frame(width: 80.0)
        .padding()
        .background(.green)
        .tint(.white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .shadow(color: .gray, radius: 5.0)
        .padding(.top, 20.0)
    }

    func Logo() -> some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                    .background(Circle().fill(Color.systemBackground))
                    .overlay(Circle().stroke(Color.systemBackground, lineWidth: 6.0))
                    .clipShape(Circle())
            }
            .padding([.top], 2.0)
            .shadow(color: .gray, radius: 5.0)
            
            Text("ATX Safe Eats")
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                .frame(width: 255.0, height: 70.0)
                .background(Color.systemBackground)
        }
        .foregroundColor(.green)
        .dismissKeyboardOnTap()
    }
}

#Preview {
    SearchView(.constant(.search))
        .environment(SearchViewModel(SocrataAPIClient()))
}
