//
//  ClientError.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import Foundation

enum ClientError: Error, LocalizedError {
    case invalidUrl, decodingError, emptyValue, invalidLocation, invalidResponse, networkError, emptyTextSearchResponse, emptyProximitySearchResponse, notInBounds
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "The search value cannot be empty. Please enter a value."
        case .emptyTextSearchResponse:
            return "Your search did not yield any results. Try shortening the restuarant name or searching with fewer words"
        case .emptyProximitySearchResponse:
            return "Your search area did not yield any results. Please move the map and try again."
        case .networkError:
            return "A network error occurred. Please check your connection and try again."
        case .invalidLocation:
            return "Something went wrong with getting the location."
        case .notInBounds:
            return "The area you are trying to serach is not in the Austin area. Please move the map and try again"
        default:
            return "Unknown Error"
        }
    }

}
