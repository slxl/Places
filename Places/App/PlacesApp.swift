//
//  PlacesApp.swift
//  Places
//

import SwiftUI

@main
struct PlacesApp: App {
    @State private var appCoordinator: AppCoordinator

    init() {
        _appCoordinator = State(initialValue: AppCoordinator(dependencies: AppContainer()))
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
