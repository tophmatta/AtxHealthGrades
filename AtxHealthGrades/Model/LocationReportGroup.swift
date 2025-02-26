//
//  LocationReportGroup.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 2/25/25.
//
import CoreLocation

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
