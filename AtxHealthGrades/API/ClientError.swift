//
//  ClientError.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 7/23/24.
//

import Foundation

enum ClientError: Error, LocalizedError {
    case invalidUrl, decodingError, emptyInputValue, invalidLocation, invalidResponse, networkError, emptyResponse, emptyTextSearchResponse, emptyProximitySearchResponse, notInBounds, locationServicesNotEnabled
    
    var errorDescription: String? {
        switch self {
        case .emptyInputValue:
            return "Empty Text"
        case .emptyResponse, .emptyTextSearchResponse, .emptyProximitySearchResponse:
            return "No Results"
        case .networkError:
            return "Network Issue"
        case .invalidLocation:
            return "Location Issue"
        case .notInBounds:
            return "Not in City Limits"
        case .locationServicesNotEnabled:
            return "No Location Services"
        default:
            return "Unknown Error"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .emptyInputValue:
            return "Please enter a value."
        case .emptyResponse:
            return "Please try again."
        case .emptyTextSearchResponse:
            return "Try searching with fewer words or perform a map radius search."
        case .emptyProximitySearchResponse:
            return "Please move the map and try again."
        case .networkError:
            return "Please check your connection and try again."
        case .invalidLocation:
            return "Something went wrong with getting the location."
        case .notInBounds:
            return "The area you are trying to search is not in the Austin area. Please move the map and try again"
        case .locationServicesNotEnabled:
            return "Enable location services by toggling the Location Services switch in Settings > Privacy."
        default:
            return "Unknown Error"
        }
    }
}
