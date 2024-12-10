//
//  SearchBar.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/22/24.
//
import SwiftUI

struct SearchBar: View {
    @Environment(SearchViewModel.self) var searchViewModel
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            SearchField()
            ClearButton()
        }
        .padding(15)
        
    }
    
    @ViewBuilder
    func SearchField() -> some View {
        TextField("", text: $text, prompt: Text("Enter a Restaurant Name"))
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 20)
            .background(
                Capsule()
                    .fill(.surface)
                    .shadow(radius: 5)
            )
            .foregroundStyle(.onSurface)
            .focused($isFocused)
            .onSubmit {
                Task {
                    await searchViewModel.triggerSearch(value: text)
                    isFocused = false
                }
            }
            .keyboardType(.webSearch)
            .disableAutocorrection(true)
            .ignoresSafeArea(.keyboard)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
            }
    }
}

struct ClearButton: View {
    @Environment(MapViewModel.self) var viewModel
    
    var body: some View {
        if !viewModel.currentPOIs.isEmpty {
            Button {
                viewModel.clearPOIs()
            } label: {
                Text("Clear")
                    .foregroundStyle(.green)
                    .padding(10)
            }
            .background(
                Capsule()
                    .fill(.surface)
                    .shadow(radius: 5)
            )
        }
    }
}


#Preview {
    HStack {
        SearchBar()
            .environment(SearchViewModel(SocrataAPIClient()))
        ClearButton()
            .environment(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), poiGroup: LocationReportGroup.test))
    }
    .padding(.horizontal, 10)
}
