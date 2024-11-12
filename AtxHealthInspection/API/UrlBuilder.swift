//
//  UrlBuilder.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/5/24.
//

import Foundation

struct UrlBuilder {
    let path: String
    var queryItems: [URLQueryItem] = []
}


extension UrlBuilder {
    static func create() -> UrlBuilder {
        return Self(path: Constants.Api.path)
    }
        
    func addQuery(_ query: String) -> UrlBuilder {
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
    
    static var empty: UrlBuilder {
        UrlBuilder(path: "")
    }
}
