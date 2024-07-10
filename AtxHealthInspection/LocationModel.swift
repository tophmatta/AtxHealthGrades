//
//  LocationModel.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/8/24.
//

import Combine
import CoreLocation

class LocationModel: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: CLLocation?
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        $authorisationStatus
            .sink { [weak self] newStatus in
                guard let self else { return }
                
                if newStatus.isAuthorized && authorisationStatus.isNotAuthorized {
                    startUpdatingLocation()
                }
            }.store(in: &cancellables)
    }

    public func requestAuthorisation() {
        locationManager.requestWhenInUseAuthorization()
    }
        
    func startUpdatingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func checkStatus() {
        // TODO: handle if user denies - show some kind of UI/modal
        if authorisationStatus.isNotAuthorized {
            requestAuthorisation()
        } else if lastLocation == nil && authorisationStatus.isAuthorized {
            startUpdatingLocation()
        }
    }
}

extension LocationModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorisationStatus = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
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
