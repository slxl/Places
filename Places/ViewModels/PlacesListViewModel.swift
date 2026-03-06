//
//  PlacesListViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
final class PlacesListViewModel {
    private(set) var locations: [Location]

    private let locationService: LocationService
    private let wikipediaRouter: WikipediaRouter

    init(locationService: LocationService, wikipediaRouter: WikipediaRouter) {
        self.locationService = locationService
        self.wikipediaRouter = wikipediaRouter
        self.locations = locationService.loadAllLocations()
    }

    func openLocation(_ location: Location) {
        wikipediaRouter.openPlaces(lat: location.lat, lon: location.lon, name: location.name)
    }

    func addCustomLocation(lat: Double, lon: Double, name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = trimmed.isEmpty ? "\(lat), \(lon)" : trimmed
        let location = Location(
            name: displayName,
            lat: lat,
            lon: lon,
            customId: UUID().uuidString
        )
        locationService.saveCustomLocation(location)
        locations = locationService.loadAllLocations()
    }
}
