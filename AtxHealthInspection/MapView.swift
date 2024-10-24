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
    
    var body: some View {
        ZStack {
            Map(position: $viewModel.cameraPosition) {
                UserAnnotation()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.goToUserLocation()
                        }
                    } label: {
                        Image(systemName: "location.fill")
                            .frame(width: 10, height: 10)
                            .padding()
                            .background(Rectangle().fill(Color("tabBarBackground").opacity(0.8)))
                            .clipShape(
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                            )
                            .foregroundColor(Color.green)
                            .padding([.trailing, .bottom])
                    }
                }
            }
        }
        .onAppear {
            viewModel.checkLocationStatus()
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapViewModel(SocrataAPIClient(), locationModel: LocationModel()))
}
