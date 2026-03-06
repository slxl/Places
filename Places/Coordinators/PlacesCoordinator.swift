//
//  PlacesCoordinator.swift
//  Places
//

import Observation

@Observable
final class PlacesCoordinator {
    let viewModel: PlacesListViewModel
    let wikipediaRouter: WikipediaRouter
    var presentedRoute: PlacesRoute?

    init(dependencies: AppDependencies) {
        self.wikipediaRouter = dependencies.wikipediaRouter
        self.viewModel = PlacesListViewModel(
            locationService: dependencies.locationService,
            wikipediaRouter: dependencies.wikipediaRouter
        )
    }

    func showCustomLocation() {
        presentedRoute = .customLocation
    }

    func dismissRoute() {
        presentedRoute = nil
    }

    func addCustomLocation(lat: Double, lon: Double, name: String) {
        viewModel.addCustomLocation(lat: lat, lon: lon, name: name)
        dismissRoute()
    }
}
