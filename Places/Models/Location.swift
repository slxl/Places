//
//  Location.swift
//  Places
//

import Foundation

struct Location: Codable, Identifiable {
    var id: String { "\(lat)-\(lon)" }
    let name: String
    let lat: Double
    let lon: Double
}

enum LocationsLoader {
    static func load() -> [Location] {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        return (try? JSONDecoder().decode([Location].self, from: data)) ?? []
    }
}
