//
//  MapViewModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/8/24.
//

import _MapKit_SwiftUI
import Combine
import CoreLocation
import Foundation
import MapKit


/*
 - search radius of 1 mile and display tappable POIs to review health grade and get directions
 */

@MainActor
class MapViewModel: ObservableObject {
    let client: ISocrataClient
    let locationModel: LocationModel
    var lastLocation: CLLocationCoordinate2D? {
        didSet {
            if oldValue == nil && lastLocation != nil {
                goToUserLocation()
            }
        }
    }
    
    @Published var currentPOIs: [PointOfInterest] = []
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    private var locationSubscriber: Set<AnyCancellable> = []
    
    init(_ client: ISocrataClient, locationModel: LocationModel = LocationModel(), poi: PointOfInterest? = nil) {
        self.client = client
        self.locationModel = locationModel
        if let poi {
            self.currentPOIs.append(poi)
        }
        
        locationModel.$lastLocation
            .throttle(for: .seconds(3), scheduler: DispatchQueue.main, latest: true)
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self else { return }
                lastLocation = location.coordinate
            }.store(in: &locationSubscriber)
    }
    
    func clear() {
        currentPOIs.removeAll()
    }
    
    func displayLocation(_ poi: PointOfInterest) {
        clear()
        currentPOIs = [poi]
        goToPoiLocation()
    }
    
    func triggerProximitySearch() {
        Task {
            guard let lastLocation else { return }
            let results = try await client.searchByLocation(lastLocation)
            results.forEach { report in
                if let loc = report.coordinate {
                    currentPOIs.append(PointOfInterest(name: report.restaurantName, address: report.address, coordinate: loc))
                }
            }
        }
    }
    
    func goToPoiLocation() {
        guard let first = currentPOIs.first else { return }
        cameraPosition = .camera(.init(centerCoordinate: first.coordinate, distance: 1000))
    }
    
    func goToUserLocation() {
        cameraPosition = .userLocation(fallback: .automatic)
    }
    
    func checkLocationStatus() {
        locationModel.checkStatus()
    }
    
    func openInMaps(coordinate: CLLocationCoordinate2D, placeName: String? = nil) {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        destination.name = placeName
        
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

struct PointOfInterest: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

extension PointOfInterest: Equatable {
    static func == (lhs: PointOfInterest, rhs: PointOfInterest) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension PointOfInterest {
    static let test =
    PointOfInterest(
        name: "Apple Park",
        address: "One Apple Park Way, Cupertino, CA 95014",
        coordinate: CLLocationCoordinate2D(latitude: 37.334643800000016, longitude: -122.00912193752882)
    )
}
#endif
