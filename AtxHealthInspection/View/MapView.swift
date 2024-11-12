//
//  MapView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/8/24.
//

import SwiftUI
import MapKit
import Collections

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @State private var selected: LocationReportGroup?
    @State private var mapCenter: CLLocationCoordinate2D?
    
    @State private var showDetail = false
    @State private var isSearching = false
    
    var body: some View {
        ZStack {
            Map(position: $viewModel.cameraPosition) {
                UserAnnotation()
                ForEach(viewModel.currentPOIs.elements, id: \.key) { element in
                    Annotation("", coordinate: element.value.coordinate) {
                        MapMarker(group: element.value, selected: $selected)
                    }
                }
            }
            .sheet(item: $selected) {
                ProximityResultsView(group: $0)
            }
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    MapActionButton(type: .radius) {
                        launchProximitySearch()
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
            .onAppear {
                viewModel.checkLocationAuthorization()
            }
            .onMapCameraChange(frequency: .onEnd) { mapCameraUpdateContext in
                mapCenter = mapCameraUpdateContext.camera.centerCoordinate
            }
            
            AppProgressView(isEnabled: $isSearching)
        }
    }
    
    private func launchProximitySearch() {
        isSearching = true
        Task {
            await viewModel.triggerProximitySearch(at: mapCenter)
            isSearching = false
        }
    }    
}

private struct MapMarker: View {
    let group: LocationReportGroup
    
    @Binding var selected: LocationReportGroup?
    
    var body: some View {
        Image(systemName: "mappin.square.fill")
            .resizable()
            .annotationSize()
            .foregroundStyle(.white, .yellow)
            .onTapGesture {
                selected = selected == group ? nil : group
            }
    }
}


#Preview {
    MapView()
        .environmentObject(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), poiGroup: LocationReportGroup.test))
}
