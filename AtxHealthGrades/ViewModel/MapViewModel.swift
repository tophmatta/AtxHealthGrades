//
//  MapViewModel.swift
//  AtxHealthGrades
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
    private let locationService: LocationService
    
    var lastLocation: CLLocationCoordinate2D? {
        didSet {
            if oldValue == nil && lastLocation != nil && poiData.isEmpty {
                try? goToUserLocation()
            }
        }
    }
    
    // Use ordered dictionary for displaying annotations
    var poiData: OrderedDictionary<AddressKey, LocationReportGroup> = [:] {
        willSet {
            updateCameraPosition(for: newValue)
        }
    }
    var historicalData = [Report]()
    var textSearchData = [Report]()
    var cameraPosition: MapCameraPosition = .automatic
    
    private var subs: Set<AnyCancellable> = []
    
    init(_ client: SocrataClientProtocol, locationService: LocationService = LocationService()) {
        self.client = client
        self.locationService = locationService
        
        locationService.$userLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self else { return }
                lastLocation = location.coordinate
            }.store(in: &subs)
    }
    
    func clearPoiData() {
        poiData.removeAll()
    }
    
    func clearHistoricalData() {
        historicalData.removeAll()
    }
    
    func clearTextSearchData() {
        textSearchData.removeAll()
    }
    
    func updatePOIs(_ pois: [String : LocationReportGroup]) {
        clearPoiData()
        poiData = pois.toOrderedDictionary()
    }
    
    func getReports(around location: CLLocationCoordinate2D) async throws {
        let results = try await client
                                .getReports(inRadiusOf: location)
                                .filterOldDuplicates()
        
        let poiGroup = results.reduce(into: [AddressKey: LocationReportGroup]()) { dict, result in
            guard let coordinate = result.coordinate else { return }
            let maybeDefault = LocationReportGroup(data: [], address: result.address, coordinate: coordinate)
            dict[result.parentId, default: maybeDefault].data.append(result)
        }
        
        updatePOIs(poiGroup)
    }
    
    func getReports(with name: String) async throws {
        textSearchData = try await client
                                    .getReports(byName: name)
                                    .filterOldDuplicates()
                                    .sorted { curr, next in
                                        guard let curr = curr.coordinate,
                                                let next = next.coordinate,
                                                let lastLocation,
                                                locationService.authorizationStatus.isAuthorized // if not authorized, returns unsorted results
                                        else { return false }
                                        
                                        // sort results in ref to user location
                                        return curr.distance(from: lastLocation) < next.distance(from: lastLocation)
                                    }
    }
    
    func getAllReports(with facilityId: String) async -> [Report] {
        historicalData = try! await client.getReports(forRestaurantWith: facilityId).sorted { $0.date > $1.date }
        return historicalData
    }
        
    func goToUserLocation() throws {
        guard lastLocation != nil else {
            throw ClientError.locationServicesNotEnabled
        }

        cameraPosition = .userLocation(fallback: .automatic)
    }
    
    func checkLocationAuthorization() {
        locationService.requestOrStartService()
    }
    
    private func updateCameraPosition(for results: OrderedDictionary<AddressKey, LocationReportGroup>) {
        if results.elements.count == 1 {
            cameraPosition = .camera(.init(centerCoordinate: results.values.first!.coordinate, distance: 1000))
        } else if results.elements.count > 1  {
            let allCoords = results.values.map { $0.coordinate }
            
            cameraPosition =
                if let center = LocationUtils.boundingBoxCenter(of: allCoords) {
                    .camera(.init(centerCoordinate: center, distance: 3000))
                } else {
                    .automatic
                }
        }
    }
    
    func updateCameraPosition(to center: CLLocationCoordinate2D) {
        cameraPosition = .camera(.init(centerCoordinate: center, distance: 15000))
    }
}


