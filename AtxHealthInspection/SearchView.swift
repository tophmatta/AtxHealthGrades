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
    @Environment(\.isPreview) private var isPreview: Bool
    
    
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
    }
    
    func Logo() -> some View {
        VStack {
            HStack(alignment: .center) {
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .background(Circle().fill(Color.systemBackground))
                        .overlay(Circle().stroke(Color.systemBackground, lineWidth: 6))
                        .clipShape(Circle())
            }
            .padding([.top], 2)
            .shadow(color: Color.gray, radius: 5)
            
            Text("ATX Safe Eats")
                .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                .frame(width: 255, height: 70)
                .background(Color.systemBackground)
        }
        .foregroundColor(.green)
    }
    
    func FilterControl() -> some View {
        HStack(alignment: .center) {
            Spacer()
            Picker("Filter", selection: $viewModel.filterType) {
                ForEach(FilterType.allCases) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .shadow(color: Color.gray, radius: 5)
            .background(Color.systemBackground)
            Spacer()
        }
        .padding([.top, .leading, .trailing])
        .padding(.bottom, 45)
    }
    
    func SearchBarAndButton() -> some View {
        VStack(spacing: 15) {
            TextField("Search", text: $viewModel.searchText)
                .padding()
                .background(Color("tabBarBackground"))
                .clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
                )
                .padding([.leading, .trailing], 10)
                .shadow(color: Color.gray, radius: 5)
                .foregroundStyle(Color("searchTextColor"))
            
            Button {
                //TODO
            } label: {
                Text("Search")
                    .font(.title2)
                    .bold()
            }
            .frame(width: 80)
            .padding()
            .background(Color.green)
            .tint(Color.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .shadow(color: Color.gray, radius: 5)
            .padding(.top, 20)
            Spacer()
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environment(\.isPreview, true)
}
