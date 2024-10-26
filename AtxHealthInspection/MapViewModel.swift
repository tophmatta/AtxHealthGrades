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
    
    @Published var currentPOI: PointOfInterest?
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    private var locationSubscriber: Set<AnyCancellable> = []
    
    init(_ client: ISocrataClient, locationModel: LocationModel = LocationModel(), currentPoi: PointOfInterest? = nil) {
        self.client = client
        self.locationModel = locationModel
        self.currentPOI = currentPoi
        
        locationModel.$lastLocation
            .throttle(for: .seconds(3), scheduler: DispatchQueue.main, latest: true)
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self else { return }
                lastLocation = location.coordinate
            }.store(in: &locationSubscriber)
    }
        
    func displayLocation(_ poi: PointOfInterest) {
        currentPOI = poi
        goToPoiLocation()
    }
    
    func goToPoiLocation() {
        guard let loc = currentPOI?.coordinate else { return }
        cameraPosition = .camera(.init(centerCoordinate: loc, distance: 1000))
    }
    
    func goToUserLocation() {
        cameraPosition = .userLocation(fallback: .automatic)
    }
    
    func checkLocationStatus() {
        locationModel.checkStatus()
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
