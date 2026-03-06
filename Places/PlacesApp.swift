//
//  PlacesApp.swift
//  Places
//
//  Created by Slava Khlichkin on 05/03/2026.
//

import SwiftUI

@main
struct PlacesApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: PlacesListViewModel(
                    locationService: container.locationService,
                    wikipediaRouter: container.wikipediaRouter
                ),
                wikipediaRouter: container.wikipediaRouter
            )
        }
    }
}
