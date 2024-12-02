//
//  SearchBar.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/22/24.
//
import SwiftUI

struct SearchBar: View {
    @Environment(SearchViewModel.self) var viewModel
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
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
                    await viewModel.triggerSearch(value: text)
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

#Preview {
    HStack {
        SearchBar()
            .environment(SearchViewModel(SocrataAPIClient()))
        ClearButton()
            .environment(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), poiGroup: LocationReportGroup.test))
    }
    .padding(.horizontal, 10)
}
