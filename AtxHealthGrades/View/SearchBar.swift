//
//  SearchBar.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 11/22/24.
//
import SwiftUI

struct HeaderComponents: View {
    @Binding var segmentedSelection: Segment
    @State private var text: String = ""
    @FocusState private var isSearchFocused: Bool
    
    let radiusSearchAction: () -> ()
    let textSearchAction: (String) -> ()
    
    var body: some View {
        GeometryReader { proxy in
            unfocusSearchBarTappableView
            ClearButton()
            
            VStack(spacing: 15) {
                SegmentedPicker(selection: $segmentedSelection)
                    .frame(width: proxy.size.width * 0.4)
                Group {
                    switch segmentedSelection {
                    case .text:
                        searchBar
                            .frame(width: proxy.size.width * 0.85)
                    case .radius:
                        radiusSearchButton
                    }
                }
                .animation(.bouncy, value: segmentedSelection)
                Spacer()
            }
            .frame(width: proxy.size.width)
        }
    }
    
    @ViewBuilder
    private var radiusSearchButton: some View {
        Button {
            radiusSearchAction()
        } label: {
            Text("Search Area")
                .padding(5)
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.semibold)
        }
        .tint(.green)
        .foregroundStyle(.surface)
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
        .shadow(radius: 5)
        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .opacity))
    }
    
    @ViewBuilder
    private var searchBar: some View {
        TextField("", text: $text, prompt: Text("Enter a Restaurant Name"))
            .padding([.vertical, .trailing], 10)
            .padding(.leading, 20)
            .background(
                Capsule()
                    .fill(.surface)
                    .shadow(radius: 5)
            )
            .foregroundStyle(.onSurface)
            .focused($isSearchFocused)
            .onSubmit {
                textSearchAction(text)
                isSearchFocused = false
            }
            .keyboardType(.webSearch)
            .disableAutocorrection(true)
            .ignoresSafeArea(.keyboard)
            .transition(.asymmetric(insertion: .push(from: .leading), removal: .opacity))
    }
    
    @ViewBuilder
    private var unfocusSearchBarTappableView: some View {
        Color.black
            .opacity(isSearchFocused ? 0.05 : 0.0)
            .ignoresSafeArea(.all)
            .onTapGesture {
                isSearchFocused = false
            }
    }
}

struct ClearButton: View {
    @Environment(MapViewModel.self) var viewModel
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Spacer()
                if !viewModel.poiData.isEmpty {
                    Button {
                        viewModel.clearPoiData()
                    } label: {
                        Text("Clear Map")
                            .foregroundStyle(.green)
                            .font(.caption)
                            .padding(10)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.surface)
                            .shadow(radius: 5)
                    )
                    .padding(.trailing, 20)
                }
            }
        }
    }
}

private struct SegmentedPicker: View {
    @Binding var selection: Segment
    
    init(selection: Binding<Segment>) {
        self._selection = selection
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.green)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor.surface
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Search Mode")
                .font(.callout)
                .foregroundStyle(Color.gray)
                .padding(.vertical, 3)
            Picker("", selection: $selection) {
                ForEach(Segment.allCases, id: \.self) { segment in
                    Text(segment.rawValue.capitalized).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing, .bottom], 8)
        }
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 10)
        )
    }
}

#Preview {
    MapView(poiSelected: .constant(nil))
        .environment(MapViewModel(SocrataAPIClient()))
        .preferredColorScheme(.dark)
}


