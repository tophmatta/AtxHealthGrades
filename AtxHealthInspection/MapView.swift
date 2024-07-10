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
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
        }
        .onAppear {
            viewModel.checkLocationStatus()
        }
    }
}

#Preview {
    MapView()
}
