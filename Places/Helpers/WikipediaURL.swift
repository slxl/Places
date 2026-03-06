//
//  WikipediaURL.swift
//  Places
//

import Foundation

enum WikipediaURL {
    static func placesURL(lat: Double, lon: Double, name: String?) -> URL? {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "name", value: name ?? "")
        ]
        return components.url
    }
}
