//
//  RequestBuilder.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/5/24.
//

import Foundation

struct RequestBuilder {
    let path: String
    var queryItems: [URLQueryItem] = []
}


extension RequestBuilder {
    static func create() -> RequestBuilder {
        return Self(path: Constants.Api.path)
    }
        
    func addQuery(_ query: String) -> RequestBuilder {
        var builder = self
        builder.queryItems.append(URLQueryItem(name: "$where", value: query))

        return builder
    }
    
    func build() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.Api.host
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
    
    static var empty: RequestBuilder {
        RequestBuilder(path: "")
    }
}
