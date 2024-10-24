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
                zoomCameraToUser()
            }
        }
    }
    
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    private var locationSubscriber: Set<AnyCancellable> = []
    
    init(_ client: ISocrataClient, locationModel: LocationModel = LocationModel()) {
        self.client = client
        self.locationModel = locationModel
        setupLocationObserver()
    }
    
    func checkLocationStatus() {
        locationModel.checkStatus()
    }
    
    func zoomCameraToUser() {
        cameraPosition = .userLocation(fallback: .automatic)
    }
    
    private func setupLocationObserver() {
        locationModel.$lastLocation
            .throttle(for: .seconds(3), scheduler: DispatchQueue.main, latest: true)
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self else { return }
                lastLocation = location.coordinate
            }.store(in: &locationSubscriber)
    }
}
