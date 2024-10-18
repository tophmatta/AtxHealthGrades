//
//  LocationModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/8/24.
//

import Combine
import CoreLocation

@MainActor
class LocationModel: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: CLLocation?
    
    private lazy var locationManager = {
        CLLocationManager()
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        observerAuthorizationStatus()
    }
    
    func checkStatus() {
        if authorizationStatus.isNotAuthorized {
            requestAuthorisation()
        } else if lastLocation == nil && authorizationStatus.isAuthorized {
            startUpdatingLocation()
        }
    }

    private func requestAuthorisation() {
        locationManager.requestWhenInUseAuthorization()
    }
        
    private func startUpdatingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
        
    private func observerAuthorizationStatus() {
        $authorizationStatus
            .sink { [weak self] newStatus in
                guard let self else { return }
                
                if newStatus.isAuthorized && authorizationStatus.isNotAuthorized {
                    startUpdatingLocation()
                }
            }.store(in: &cancellables)
    }
}

extension LocationModel: @preconcurrency CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard 
            let location = locations.last,
            location.coordinate.isValid()
        else { return }
        self.lastLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

private extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        return self == .authorizedWhenInUse || self == .authorizedAlways
    }
    
    var isNotAuthorized: Bool {
        return self == .notDetermined
    }
}
