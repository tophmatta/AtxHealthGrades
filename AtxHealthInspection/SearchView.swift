//
//  SearchView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import SwiftUI

struct SearchView: View {
    
    init() {
      UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    @EnvironmentObject var viewModel: SearchViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            FoodBackground().ignoresSafeArea(edges: [.top, .leading, .trailing])
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    FilterControl()
                    Logo()
                    SearchBarAndButton()
                }
            }
        }
        .sheet(item: $viewModel.currentReport, onDismiss: {
            viewModel.dismissSheet()
        }) { item in
            VStack {
                Text("Name: \(item.restaurantName)")
                Text("Score: \(item.score)")
                Text("Last inspection: \(item.date)")
            }
            .presentationDetents([.height(200)])
            .presentationCompactAdaptation(.none)
        }

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
            .shadow(color: Color.gray, radius: 5.0)
            
            Text("ATX Safe Eats")
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                .frame(width: 255.0, height: 70.0)
                .background(Color.systemBackground)
        }
        .foregroundColor(.green)
    }
    
    func FilterControl() -> some View {
        HStack(alignment: .center) {
            Spacer()
            Picker("Filter", selection: $viewModel.searchType) {
                ForEach(SearchType.allCases) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .shadow(color: Color.gray, radius: 5.0)
            .background(Color.systemBackground)
            Spacer()
        }
        .padding([.top, .leading, .trailing])
        .padding(.bottom, 45.0)
    }
    
    func SearchBarAndButton() -> some View {
        VStack(spacing: 15.0) {
            TextField("Search", text: $searchText)
                .padding()
                .background(Color("tabBarBackground"))
                .clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
                )
                .padding([.leading, .trailing], 10.0)
                .shadow(color: Color.gray, radius: 5.0)
                .foregroundStyle(Color("searchTextColor"))
            
            Button {
                viewModel.triggerSearch(value: searchText)
            } label: {
                Text("Search")
                    .font(.title2)
                    .bold()
            }
            .frame(width: 80.0)
            .padding()
            .background(Color.green)
            .tint(Color.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .shadow(color: Color.gray, radius: 5.0)
            .padding(.top, 20.0)
            Spacer()
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel(SocrataClient()))
}
