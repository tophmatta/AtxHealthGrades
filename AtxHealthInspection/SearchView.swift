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
            FoodBackground()
                .ignoresSafeArea(edges: [.top, .leading, .trailing])
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Spacer()
                        Picker("Filter", selection: $viewModel.filterType) {
                            ForEach(FilterType.allCases) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .background(Color.white)
                        .frame(width: geometry.size.width * 0.75)
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        TextField("Search", text: $viewModel.searchText)
                            .padding()
                            .background(Constants.lightGray)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous))
                            .padding([.leading, .trailing], 10)
                        
                        Button {
                            //TODO
                        } label: {
                            Text("Search").bold()
                        }
                        .frame(width: geometry.size.width * 0.2)
                        .padding()
                        .background(Color.green)
                        .tint(Color.white)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        .padding()
                    }
                    Spacer()
                    
                }
            }

        }
    }
    
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environment(\.isPreview, true)
}
