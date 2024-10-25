//
//  ClientError.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import Foundation

enum ClientError: Error, LocalizedError {
    case invalidUrl, decodingError, emptyValue, invalidLocation, invalidResponse, networkError, emptyResponse
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "The search value cannot be empty. Please enter a value."
        case .emptyResponse:
            return "Your search did not yield any results. Try shortening the restuarant name or searching with fewer words"
        case .networkError:
            return "A network error occurred. Please check your connection and try again."
        case .invalidLocation:
            return "Something went wrong with getting the location."
        default:
            return "Unknown Error"
        }
    }

}
