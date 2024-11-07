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



/*
 TODO:
 - explore mklocalsearch to see what other details i can pull up on a place and perhaps use a built in detail accessory view to show
 - on tap of location row - query restauarnt for all health inspections and show a list from most to lest recent
 - decouple radius search from user location - show trans circle that can be moved around to perform search and display annotations for that area
 - proper error handling in proximity search - no internet, no results, etc.
 */

@MainActor
class MapViewModel: ObservableObject {
    typealias AddressKey = String
    
    let client: ISocrataClient
    let locationModel: LocationModel
    var lastLocation: CLLocationCoordinate2D? {
        didSet {
            if oldValue == nil && lastLocation != nil {
                goToUserLocation()
            }
        }
    }
    
    // Use ordered dictionary for displaying annotations
    @Published var currentPOIs: OrderedDictionary<AddressKey, LocationReportGroup> = [:]
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    private var subs: Set<AnyCancellable> = []
    
    init(_ client: ISocrataClient, locationModel: LocationModel = LocationModel(), poiGroup: LocationReportGroup? = nil) {
        self.client = client
        self.locationModel = locationModel
        if let poiGroup {
            self.currentPOIs[poiGroup.id] = poiGroup
        }
        
        locationModel.$lastLocation
            .throttle(for: .seconds(3), scheduler: DispatchQueue.main, latest: true)
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self else { return }
                lastLocation = location.coordinate
            }.store(in: &subs)
    }
    
    func clear() {
        currentPOIs.removeAll()
    }
    
    func updatePOIs(_ pois: [String : LocationReportGroup]) {
        clear()
        currentPOIs = pois.toOrderedDictionary()
    }
    
    func triggerProximitySearch() async {
        guard let lastLocation else { return }
        
        let results: [Report] = try! await client.searchByLocation(lastLocation)
                                                        .filterOldDuplicates()
        
        let poiGroup = results.reduce(into: [AddressKey: LocationReportGroup]()) { dict, result in
            guard let coordinate = result.coordinate else { return }
            
            let data = ReportData(name: result.restaurantName, score: result.score, date: result.date)
            dict[result.address, default: LocationReportGroup(data: [], address: result.address, coordinate: coordinate)].data.append(data)
        }
        
        updatePOIs(poiGroup)
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
}

// Multiple restaurants can have same address/coordinate
struct LocationReportGroup: Identifiable {
    var data: [ReportData]
    let address: String
    let coordinate: CLLocationCoordinate2D
    var id: String { "\(address)-\(coordinate.latitude)-\(coordinate.longitude)" }
}

extension LocationReportGroup: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: LocationReportGroup, rhs: LocationReportGroup) -> Bool {
        lhs.id == rhs.id
    }
}

struct ReportData: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
    let date: Date
}

extension ReportData: Hashable {
    static func == (lhs: ReportData, rhs: ReportData) -> Bool {
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
        data: [ReportData.test],
        address: "One Apple Park Way, Cupertino, CA 95014",
        coordinate: CLLocationCoordinate2D(latitude: 37.334643800000016, longitude: -122.00912193752882)
    )
}

extension ReportData {
    static let test = ReportData(name: "Apple Park", score: 0, date: Date.now)
}
#endif
