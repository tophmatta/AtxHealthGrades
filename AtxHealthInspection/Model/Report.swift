//
//  Report.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/4/24.
//

import CoreLocation

struct Report: Decodable, Identifiable {
    var id = UUID()
    
    let restaurantName: String
    let score: Int
    let address: String
    var coordinate: CLLocationCoordinate2D? = nil
    let date: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.restaurantName = try container.decode(String.self, forKey: .restaurantName)
        
        let scoreString = try container.decode(String.self, forKey: .score)
        if let score = Int(scoreString) {
            self.score = score
        } else {
            throw DecodingError.dataCorruptedError(forKey: .score, in: container, debugDescription: "Score is not a valid integer")
        }
        
        let dateString = try container.decode(String.self, forKey: .inspectionDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .inspectionDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format")
        }
        
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
        
        guard coord.isValid() else { return }
        
        self.coordinate = coord
    }
    
    // Only for decoding JSON to flatten obj structure
    private struct HumanAddress: Decodable {
        let address: String
        let city: String
        let state: String
        let zip: String
    }
}

extension Report {
    private enum CodingKeys: String, CodingKey {
        case restaurantName, score, address, inspectionDate
        
        enum Address: CodingKey {
            case latitude, longitude, humanAddress
        }
    }
    
    private init(restaurantName: String = "N/A", score: Int = 99, address: String = "N/A", coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(), date: Date = Date()) {
        self.restaurantName = restaurantName
        self.score = score
        self.address = address
        self.coordinate = coordinate
        self.date = date
    }
}

extension Report: Hashable {
    static func == (lhs: Report, rhs: Report) -> Bool {
        return lhs.address == rhs.address && lhs.restaurantName == rhs.restaurantName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
        hasher.combine(restaurantName)
    }
}

#if DEBUG
extension Report: CustomStringConvertible {
    var description: String {
        var desc = "Restaurant Name: \(restaurantName)\n"
        desc += "Score: \(score)\n"
        desc += "Date: \(date.toReadable())\n"
        desc += "Address: \(address)\n"
        
        if let coordinate = coordinate {
            desc += "Coordinate: (\(coordinate.latitude), \(coordinate.longitude))\n"
        } else {
            desc += "Coordinate: N/A\n"
        }
        
        return desc
    }
    
    static let empty = Report()
    
    static let sample = Report(restaurantName: "Toph's Delight", score: 99, address: "123 Cucumber Lane", coordinate: CLLocationCoordinate2D(latitude: 30.194818005,longitude: -97.843463001))
}
#endif
