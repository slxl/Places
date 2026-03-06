//
//  AppContainer.swift
//  Places
//

import Foundation

struct AppContainer: AppDependencies {
    let locationService: LocationService

    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
    }
}
