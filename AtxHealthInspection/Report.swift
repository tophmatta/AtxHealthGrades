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
    let address: String
    var coordinate: CLLocationCoordinate2D? = nil
    
    struct HumanAddress: Decodable {
        let address: String
        let city: String
        let state: String
        let zip: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.restaurantName = try container.decode(String.self, forKey: .restaurantName)
        self.score = try container.decode(String.self, forKey: .score)
        
        let addressContainer = try container.nestedContainer(keyedBy: CodingKeys.Address.self, forKey: .address)
        
        let humanAddressString = try addressContainer.decode(String.self, forKey: .humanAddress)
        
        guard let humanAddressData = humanAddressString.data(using: .utf8) else {
            throw DecodingError.dataCorruptedError(forKey: .humanAddress, in: addressContainer, debugDescription: "Human address string data is corrupted")
        }
        
        let humanAddress = try JSONDecoder().decode(HumanAddress.self, from: humanAddressData)
        self.address = humanAddress.address
        
        guard
            let latStr = try addressContainer.decodeIfPresent(String.self, forKey: .latitude),
            let lonStr = try addressContainer.decodeIfPresent(String.self, forKey: .longitude),
            let lat = Double(latStr),
            let lon = Double(lonStr)
        else { return }
        
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        guard CLLocationCoordinate2DIsValid(coord) else { return }
        
        self.coordinate = coord
    }
}

extension Report: CustomStringConvertible {
    private enum CodingKeys: String, CodingKey {
        case restaurantName, score, address
         
        enum Address: CodingKey {
            case latitude, longitude, humanAddress
        }
    }

    private init(restaurantName: String = "N/A", score: String = "N/A", address: String = "N/A", coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        self.restaurantName = restaurantName
        self.score = score
        self.address = address
        self.coordinate = coordinate
    }
    
    var description: String {
        var desc = "Restaurant Name: \(restaurantName)\n"
        desc += "Score: \(score)\n"
        desc += "Address: \(address)\n"
        
        if let coordinate = coordinate {
            desc += "Coordinate: (\(coordinate.latitude), \(coordinate.longitude))\n"
        } else {
            desc += "Coordinate: N/A\n"
        }
        
        return desc
    }

    static var empty: Report {
        return Report()
    }
}
