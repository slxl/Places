//
//  AppCoordinator.swift
//  Places
//

import Observation

@Observable
final class AppCoordinator {
    let placesCoordinator: PlacesCoordinator

    init(dependencies: AppDependencies) {
        self.placesCoordinator = PlacesCoordinator(dependencies: dependencies)
    }
}
