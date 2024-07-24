//
//  SearchError.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import Foundation

enum SearchError: Error, LocalizedError {
    case invalidUrl, decodingError, emptyValue, invalidLocation, invalidResponse, networkError, emptyResponse
    
    var errorDescription: String? {
        switch self {
        case .emptyValue:
            return "The search value cannot be empty. Please enter a value."
        case .emptyResponse:
            return "Your search did not yield any results."
        case .networkError:
            return "A network error occurred. Please check your connection and try again."
        default:
            return "Unknown Error"
        }
    }

}
