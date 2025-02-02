//
//  MapView.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/8/24.
//

import SwiftUI
import MapKit
import Collections

struct MapView: View {
    @Environment(MapViewModel.self) var mapViewModel
    @Environment(\.scenePhase) var scenePhase
    @Binding var poiSelected: LocationReportGroup?
    @State private var mapCenter: CLLocationCoordinate2D?
    
    @State private var isKeyboardVisible = false
    @State private var showDetail = false
    @State private var isSearching = false
    @State private var error: Swift.Error?
    
    @State private var circleOverlay: MapCircle?
    
    var body: some View {
        @Bindable var bindableMapViewModel = mapViewModel
        
        ZStack {
            Map(position: $bindableMapViewModel.cameraPosition) {
                UserAnnotation()
                circleOverlay?
                    .foregroundStyle(.green.opacity(0.1))
                    .stroke(.green.opacity(0.5), lineWidth: 2.0)
                ForEach(mapViewModel.poiData.elements, id: \.key) { element in
                    Annotation("", coordinate: element.value.coordinate) {
                        MapMarker(group: element.value, selected: $poiSelected)
                    }
                    .annotationTitles(.hidden)
                }
            }
            .mapStyle(MapStyle.standard(pointsOfInterest: .excludingAll))
            .sheet(item: $poiSelected) {
                RestaurantHistorySelectionView(group: $0)
            }
            .sheet(isPresented: $bindableMapViewModel.textSearchData.isNotEmpty()) {
                TextSearchResultView(reports: mapViewModel.textSearchData)
                    .presentationDetents([.medium, .large])
                    .presentationCompactAdaptation(.none)
            }
            .errorAlert(error: $error)
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    MapUtilityButton(type: .radius, action: radiusSearchAction)
                    MapUtilityButton(type: .location, action: userLocationAction)
                }
            }
            .overlay(alignment: .top) {
                SearchBar(error: $error, isSearching: $isSearching)
            }
            .onAppear {
                mapViewModel.checkLocationAuthorization()
                UITextField.appearance().clearButtonMode = .always
            }
            .onMapCameraChange(frequency: .continuous) { mapCameraUpdateContext in
                mapCenter = mapCameraUpdateContext.camera.centerCoordinate
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                guard oldValue == .inactive && newValue == .active else {
                    return
                }
                mapViewModel.checkLocationAuthorization()
            }
            
            AppProgressView(isEnabled: $isSearching)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func animateCircle(at center: CLLocationCoordinate2D) async {
        for radius in stride(from: 0.0, through: 1600.0, by: 80.0) {
            withAnimation(.linear(duration: 0.025)) {
                circleOverlay = MapCircle(center: center, radius: radius)
            }
            try? await Task.sleep(for: .milliseconds(25))
        }
    }
    
    private func launchProximitySearch(with center: CLLocationCoordinate2D) async {
        do {
            try await mapViewModel.getReports(around: center)
        } catch let clientError {
            error = clientError
        }
    }
    
    private func userLocationAction() {
        do {
            try mapViewModel.goToUserLocation()
        } catch let clientError {
            error = clientError
        }
    }
    
    private func radiusSearchAction() {
        Task {
            guard let mapCenter else { return }
            mapViewModel.clearPoiData()
            mapViewModel.updateCameraPosition(to: mapCenter)
            await animateCircle(at: mapCenter)
            isSearching = true
            await launchProximitySearch(with: mapCenter)
            isSearching = false
            circleOverlay = nil
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
            .foregroundStyle(.white, .green)
            .onTapGesture {
                selected = selected == group ? nil : group
            }
    }
}

#Preview {
    MapView(poiSelected: .constant(nil))
        .environment(MapViewModel(SocrataAPIClient()))
}
