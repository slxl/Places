//
//  PlacesCoordinator.swift
//  Places
//

import Observation
import SwiftUI

@Observable
final class PlacesCoordinator {
    let viewModel: PlacesListViewModel
    var path = NavigationPath()
    var presentedRoute: PlacesRoute?
    private let router: PlacesListRouter
    private var customLocationCoordinator: CustomLocationCoordinator?

    init(dependencies: AppDependencies) {
        let router = PlacesListRouter()
        self.router = router
        self.viewModel = PlacesListViewModel(
            locationService: dependencies.locationService,
            router: router
        )
        router.coordinator = self
    }

    @ViewBuilder
    func start() -> some View {
        PlacesRootView(coordinator: self)
    }

    func dismissPresentedRoute() {
        presentedRoute = nil
        customLocationCoordinator = nil
    }
}

extension PlacesCoordinator: PlacesListRouteCoordinating {
    func coordinate(_ route: PlacesListRouteTrigger) {
        switch route {
        case .showCustomLocation:
            let customLocationCoordinator = CustomLocationCoordinator(
                saver: viewModel,
                onDismiss: { [weak self] in
                    guard let self else { return }
                    // Defer so we don't release the viewModel while still inside viewModel.cancel()/save()
                    DispatchQueue.main.async { self.dismissPresentedRoute() }
                }
            )
            self.customLocationCoordinator = customLocationCoordinator
            let customLocationViewModel = customLocationCoordinator.start()
            presentedRoute = .customLocation(customLocationViewModel)
        case .openWikipediaPlaces:
            break
        }
    }
}
