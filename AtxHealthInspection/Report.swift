//
//  Report.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import CoreLocation

struct Report: Decodable {
    let restaurantName: String
    let score: String
    let location: Location
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: CodingKeys.restaurantName)
        let score = try container.decode(String.self, forKey: CodingKeys.score)
        let location = try container.decode(Location.self, forKey: CodingKeys.address)
        
        self.restaurantName = name
        self.score = score
        self.location = location
    }
    
    struct Location: Decodable {
        var coordinate: CLLocationCoordinate2D? = nil
        let address: String
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            
            self.address = try container.decode(String.self, forKey: CodingKeys.humanAddress)
            
            guard
                let latStr = try container.decodeIfPresent(String.self, forKey: CodingKeys.latitude),
                let lonStr = try container.decodeIfPresent(String.self, forKey: CodingKeys.longitude),
                let lat = Double(latStr),
                let lon = Double(lonStr)
            else {
                return
            }
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            guard CLLocationCoordinate2DIsValid(coord) else {
                return
            }
            
            self.coordinate = coord
        }
    }
}

extension Report: CustomStringConvertible {
    private init(restaurantName: String = "N/A", score: String = "N/A", location: Location = Location.empty) {
        self.restaurantName = restaurantName
        self.score = score
        self.location = location
    }
    
    private enum CodingKeys: CodingKey {
        case restaurantName, score, address
    }

    var description: String {
        return "name: \(restaurantName), score: \(score), address: \(location.address)"
    }
    
    static var empty: Report {
        return Report()
    }
}

private extension Report.Location {
    private init(coordinate: CLLocationCoordinate2D =  CLLocationCoordinate2D(), address: String = "N/A") {
        self.coordinate = coordinate
        self.address = address
    }

    private enum CodingKeys: CodingKey {
        case latitude, longitude, humanAddress
    }
    
    static var empty: Report.Location {
        return Report.Location()
    }
}

