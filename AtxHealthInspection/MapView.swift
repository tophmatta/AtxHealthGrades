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
    
    private let ButtonSize: CGFloat = 30.0
    private let AnnotationSize: CGFloat = 30.0

    var body: some View {
        ZStack {
            Map(position: $viewModel.cameraPosition) {
                UserAnnotation()
                if let poi = viewModel.currentPOI {
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
                                        .frame(width: ButtonSize, height: ButtonSize)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color("tabBarBackground"))
                            .cornerRadius(8)
                            .shadow(radius: 4)

                            Circle()
                                .frame(width: AnnotationSize, height: AnnotationSize)
                                .foregroundStyle(.white)
                                .overlay {
                                    Image(systemName: "mappin.square.fill")
                                        .resizable()
                                        .frame(width: AnnotationSize, height: AnnotationSize)
                                        .foregroundColor(.yellow)
                                }
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                LocationButton()
            }
            .overlay(alignment: .topTrailing) {
                if viewModel.currentPOI != nil {
                    ClearButton()
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onAppear {
            viewModel.checkLocationStatus()
        }
    }
}

private struct ClearButton: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    var body: some View {
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

private struct LocationButton: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    var body: some View {
        Button {
            withAnimation {
                viewModel.goToUserLocation()
            }
        } label: {
            Image(systemName: "location.fill")
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

#Preview {
    MapView()
        .environmentObject(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), currentPoi: PointOfInterest.test))
}
