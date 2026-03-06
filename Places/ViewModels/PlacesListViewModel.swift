//
//  PlacesListViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
final class PlacesListViewModel {
    private(set) var locations: [Location]
    var showCustomCoordinates: Bool = false

    private let wikipediaRouter: WikipediaRouter

    init(
        locationService: LocationService,
        wikipediaRouter: WikipediaRouter
    ) {
        self.locations = locationService.loadLocations()
        self.wikipediaRouter = wikipediaRouter
    }

    func openLocation(_ location: Location) {
        wikipediaRouter.openPlaces(lat: location.lat, lon: location.lon, name: location.name)
    }

    func presentCustomCoordinates() {
        showCustomCoordinates = true
    }
}
