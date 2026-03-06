//
//  LocationService.swift
//  Places
//

import Foundation

private let customLocationsKey = "Places.customLocations"

struct LocationService {
    private let defaults = UserDefaults.standard

    /// Loads baseline locations from bundled locations.json.
    func loadLocations() -> [Location] {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        return (try? JSONDecoder().decode([Location].self, from: data)) ?? []
    }

    /// Baseline from locations.json plus persisted custom locations.
    func loadAllLocations() -> [Location] {
        let baseline = loadLocations()
        let custom = loadCustomLocations()
        return baseline + custom
    }

    /// Persist a custom location (append; merge by id if desired to avoid duplicates).
    func saveCustomLocation(_ location: Location) {
        var list = loadCustomLocations()
        list.removeAll { $0.id == location.id }
        list.append(location)
        saveCustomLocations(list)
    }

    private func loadCustomLocations() -> [Location] {
        guard let data = defaults.data(forKey: customLocationsKey) else { return [] }
        return (try? JSONDecoder().decode([Location].self, from: data)) ?? []
    }

    private func saveCustomLocations(_ locations: [Location]) {
        guard let data = try? JSONEncoder().encode(locations) else { return }
        defaults.set(data, forKey: customLocationsKey)
    }
}
