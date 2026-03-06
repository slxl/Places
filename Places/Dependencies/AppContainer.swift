//
//  AppContainer.swift
//  Places
//

import Foundation

struct AppContainer: AppDependencies {
    let locationService: LocationService
    let wikipediaRouter: WikipediaRouter

    init(
        locationService: LocationService = LocationService(),
        wikipediaRouter: WikipediaRouter = WikipediaRouter()
    ) {
        self.locationService = locationService
        self.wikipediaRouter = wikipediaRouter
    }
}
