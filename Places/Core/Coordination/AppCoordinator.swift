//
//  AppCoordinator.swift
//  Places
//

import Observation
import SwiftUI

@Observable
final class AppCoordinator {
    let placesCoordinator: PlacesCoordinator

    init(dependencies: AppDependencies) {
        self.placesCoordinator = PlacesCoordinator(dependencies: dependencies)
    }

    @ViewBuilder
    func start() -> some View {
        placesCoordinator.start()
    }
}
