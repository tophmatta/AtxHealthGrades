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
import OrderedCollections

@MainActor
@Observable final class MapViewModel {
    typealias AddressKey = String
    
    private let client: SocrataClientProtocol
    private let locationModel: LocationModel
    
    var lastLocation: CLLocationCoordinate2D? {
        didSet {
            if oldValue == nil && lastLocation != nil && currentPOIs.isEmpty {
                goToUserLocation()
            }
        }
    }
    
    // Use ordered dictionary for displaying annotations
    var currentPOIs: OrderedDictionary<AddressKey, LocationReportGroup> = [:] {
        willSet {
            updateCameraPosition(for: newValue)
        }
    }
    var historicalReports = [Report]()
    var cameraPosition: MapCameraPosition = .automatic
    
    private var subs: Set<AnyCancellable> = []
    
    init(_ client: SocrataClientProtocol, locationModel: LocationModel = LocationModel(), poiGroup: LocationReportGroup? = nil) {
        self.client = client
        self.locationModel = locationModel
        if let poiGroup {
            self.currentPOIs[poiGroup.id] = poiGroup
        }
        
        locationModel.$lastLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self else { return }
                lastLocation = location.coordinate
            }.store(in: &subs)
    }
    
    func clearPOIs() {
        currentPOIs.removeAll()
    }
    
    func clearHistorical() {
        historicalReports.removeAll()
    }
    
    func updatePOIs(_ pois: [String : LocationReportGroup]) {
        clearPOIs()
        currentPOIs = pois.toOrderedDictionary()
    }
    
    func triggerProximitySearch(at location: CLLocationCoordinate2D) async throws {
        guard location.isInAustin() else {
            throw ClientError.notInBounds
        }
        
        let results = try await client.search(inRadiusOf: location).filterOldDuplicates()
        
        guard !results.isEmpty else {
            throw ClientError.emptyProximitySearchResponse
        }
        
        let poiGroup = results.reduce(into: [AddressKey: LocationReportGroup]()) { dict, result in
            guard let coordinate = result.coordinate else { return }
            
            dict[result.parentId, default: LocationReportGroup(data: [], address: result.address, coordinate: coordinate)].data.append(result)
        }
        
        updatePOIs(poiGroup)
    }
    
    func getAllReports(with facilityId: String) async {
        historicalReports = try! await client.getReports(forRestaurantWith: facilityId).sorted { $0.date > $1.date }
    }
    
    func goToUserLocation() {
        cameraPosition = .userLocation(fallback: .automatic)
    }
    
    func checkLocationAuthorization() {
        locationModel.checkAuthorization()
    }
    
    func openInMaps(coordinate: CLLocationCoordinate2D, placeName: String? = nil) {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        destination.name = placeName
        
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    private func updateCameraPosition(for results: OrderedDictionary<AddressKey, LocationReportGroup>) {
        if results.elements.count == 1 {
            cameraPosition = .camera(.init(centerCoordinate: results.values.first!.coordinate, distance: 1000))
        } else if results.elements.count > 1  {
            cameraPosition = .automatic
        }
    }
    
    func updateCameraPosition(to center: CLLocationCoordinate2D) {
        cameraPosition = .camera(.init(centerCoordinate: center, distance: 15000))
    }
}

// Multiple restaurants can have same address/coordinate
struct LocationReportGroup: Identifiable {
    var data: [Report]
    let address: String
    let coordinate: CLLocationCoordinate2D
    var id: String { address }
}

extension LocationReportGroup: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LocationReportGroup, rhs: LocationReportGroup) -> Bool {
        lhs.id == rhs.id
    }
}


private extension Dictionary {
    func toOrderedDictionary() -> OrderedDictionary<Key, Value> {
        OrderedDictionary(uniqueKeysWithValues: self)
    }
}

#if DEBUG
extension LocationReportGroup {
    static let test =
    LocationReportGroup(
        data: [Report.test],
        address: "One Apple Park Way, Cupertino, CA 95014",
        coordinate: CLLocationCoordinate2D(latitude: 37.334643800000016, longitude: -122.00912193752882)
    )
}
#endif
