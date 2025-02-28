//
//  HeaderComponents.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 11/22/24.
//
import SwiftUI

struct HeaderComponents: View {
    @Binding var segmentedSelection: Segment
    @State private var text: String = ""
    @FocusState private var isSearchFocused: Bool
    @State private var isButtonPressed = false
    
    let radiusSearchAction: () -> ()
    let textSearchAction: (String) -> ()
    
    var body: some View {
        GeometryReader { proxy in
            unfocusSearchBarTappableView
            ClearButton()
            
            VStack(spacing: 15) {
                SearchModeSegmentedPicker(selection: $segmentedSelection)
                    .frame(width: proxy.size.width * 0.4)
                Group {
                    switch segmentedSelection {
                    case .text:
                        textSearchBar
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
            isButtonPressed = true
            radiusSearchAction()
            Task { @MainActor in
                // Non-blocking because it suspends the current task rather than blocking the thread.
                try? await Task.sleep(for: .seconds(0.2))
                isButtonPressed = false
            }
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
        .sensoryFeedback(.success, trigger: isButtonPressed)
        .scaleEffect(isButtonPressed ? 0.9 : 1.0) // Slight shrink effect on press
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isButtonPressed) // Smooth animation

        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .opacity))
    }
    
    @ViewBuilder
    private var textSearchBar: some View {
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
                triggerHapticFeedback()
                textSearchAction(text)
                isSearchFocused = false
            }
            .keyboardType(.webSearch)
            .disableAutocorrection(true)
            .ignoresSafeArea(.keyboard)
            .scaleEffect(isSearchFocused ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearchFocused)
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
    
    private func triggerHapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        impactMed.impactOccurred()
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


#Preview {
    MapView(poiSelected: .constant(nil))
        .environment(MapViewModel(SocrataAPIClient()))
        .preferredColorScheme(.dark)
}


