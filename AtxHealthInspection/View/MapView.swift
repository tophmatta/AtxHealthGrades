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
    @Environment(MapViewModel.self) var mapViewModel
    @Environment(SearchViewModel.self) var searchViewModel
    @State private var poiSelected: LocationReportGroup?
    @State private var mapCenter: CLLocationCoordinate2D?
    
    @State private var isKeyboardVisible = false
    @State private var showDetail = false
    @State private var isSearching = false
    
    @State private var circleOverlay: MapCircle?
    
    var body: some View {
        @Bindable var bindableMapViewModel = mapViewModel
        @Bindable var bindableSearchViewModel = searchViewModel
        
        ZStack {
            Map(position: $bindableMapViewModel.cameraPosition) {
                UserAnnotation()
                circleOverlay?
                    .foregroundStyle(.green.opacity(0.1))
                    .stroke(.green.opacity(0.5), lineWidth: 2.0)
                ForEach(mapViewModel.currentPOIs.elements, id: \.key) { element in
                    Annotation("", coordinate: element.value.coordinate) {
                        MapMarker(group: element.value, selected: $poiSelected)
                    }
                    .annotationTitles(.hidden)
                }
            }
            .sheet(item: $poiSelected) {
                ProximityResultsView(group: $0)
            }
            .sheet(isPresented: $bindableSearchViewModel.currentReports.isNotEmpty()) {
                ReportList(reports: searchViewModel.currentReports)
                    .presentationDetents([.medium, .large])
                    .presentationCompactAdaptation(.none)
            }
            .alert(
                "Something went wrong...",
                isPresented: $bindableSearchViewModel.error.isNotNil(),
                presenting: searchViewModel.error,
                actions: { _ in },
                message: { error in
                    Text(error.localizedDescription).padding(.top, 15)
                }
            )
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    MapUtilityButton(type: .radius) {
                        Task {
                            guard let mapCenter else { return }
                            mapViewModel.clearPOIs()
                            mapViewModel.updateCameraPosition(to: mapCenter)
                            await animateCircle(at: mapCenter)
                            await launchProximitySearch(with: mapCenter)
                            circleOverlay = nil
                        }
                    }
                    MapUtilityButton(type: .location) {
                        mapViewModel.goToUserLocation()
                    }
                }
            }
            .overlay(alignment: .top) {
                SearchBar()
            }
            .onAppear {
                mapViewModel.checkLocationAuthorization()
                UITextField.appearance().clearButtonMode = .always
            }
            .onMapCameraChange(frequency: .continuous) { mapCameraUpdateContext in
                mapCenter = mapCameraUpdateContext.camera.centerCoordinate
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            AppProgressView(isEnabled: $isSearching)
        }
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
        isSearching = true
        await mapViewModel.triggerProximitySearch(at: center)
        isSearching = false
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
        .environment(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), poiGroup: LocationReportGroup.test))
}
