//
//  LocationService.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/8/24.
//

import Combine
import CoreLocation

@MainActor
class LocationService: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var userLocation: CLLocation?
    
    private lazy var locationManager = {
        CLLocationManager()
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        observeAuthStatus()
    }
    
    func requestOrStartService() {
        if authorizationStatus.isNotAuthorized {
            requestAuth()
        } else if userLocation == nil && authorizationStatus.isAuthorized {
            startService()
        }
    }
    
    private func requestAuth() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func startService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.startUpdatingLocation()
    }
    
    private func observeAuthStatus() {
        $authorizationStatus
            .sink { [weak self] newStatus in
                guard let self else { return }
                
                if newStatus.isAuthorized && authorizationStatus.isNotAuthorized {
                    startService()
                }
            }.store(in: &cancellables)
    }
}

// Location manager inits on main thread so we can guarantee the callbacks will be on the same thread
extension LocationService: @preconcurrency CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard
            let location = locations.last,
            location.coordinate.isValid()
        else { return }
        self.userLocation = location
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
