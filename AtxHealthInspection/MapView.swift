//
//  MapView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/8/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @State private var selectedPoi: PointOfInterest?
    
    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
            ForEach(viewModel.currentPOIs) { poi in
                Annotation("", coordinate: poi.coordinate) {
                    VStack {
                        VStack(spacing: 10) {
                            Text(poi.name)
                                .font(.callout)
                                .foregroundStyle(Color("searchTextColor"))
                            Divider()
                            Button {
                                viewModel.openInMaps(coordinate: poi.coordinate, placeName: poi.name)
                            } label: {
                                Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                    .resizable()
                                    .buttonSize()
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color("tabBarBackground"))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                        .opacity(selectedPoi == poi ? 1 : 0)
                        
                        Image(systemName: "mappin.square.fill")
                            .resizable()
                            .annotationSize()
                            .foregroundStyle(.white, .yellow)
                            .onTapGesture {
                                selectedPoi = selectedPoi == poi ? nil : poi
                            }
                    }
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                MapActionButton(type: .radius) {
                    viewModel.triggerProximitySearch()
                }
                MapActionButton(type: .location) {
                    viewModel.goToUserLocation()
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            ClearButton()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: viewModel.currentPOIs) {
            viewModel.cameraPosition = .automatic
        }
        .onAppear {
            viewModel.checkLocationStatus()
        }
    }
}

private struct ClearButton: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    var body: some View {
        if !viewModel.currentPOIs.isEmpty {
            Button {
                viewModel.clear()
            } label: {
                Text("Clear")
                    .foregroundStyle(.green)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7)
            }
            .background(
                Capsule()
                    .fill(Color("tabBarBackground"))
                    .shadow(radius: 5)
            )
            .padding(.trailing)
        }
    }
}

private struct MapActionButton: View {
    let type: ActionButtonType
    let action: () -> ()
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Image(systemName: type.rawValue)
                .frame(width: 10, height: 10)
                .padding()
                .background(Rectangle().fill(Color("tabBarBackground")))
                .clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                )
                .foregroundColor(Color.green)
                .padding([.trailing, .bottom])
                .shadow(radius: 5)
        }
    }
}

enum ActionButtonType: String {
    case location = "location.fill"
    case radius = "circle.dotted"
}

#Preview {
    MapView()
        .environmentObject(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), poi: PointOfInterest.test))
}
