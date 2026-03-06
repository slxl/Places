//
//  LocationService.swift
//  Places
//

import Foundation

struct LocationService {
    func loadLocations() -> [Location] {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        return (try? JSONDecoder().decode([Location].self, from: data)) ?? []
    }
}
