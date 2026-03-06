//
//  PlacesRootView.swift
//  Places
//

import SwiftUI

struct PlacesRootView: View {
    @Bindable var coordinator: PlacesCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            PlacesListView(viewModel: coordinator.viewModel)
        }
        .sheet(item: $coordinator.presentedRoute, onDismiss: {
            coordinator.dismissPresentedRoute()
        }) { route in
            switch route {
            case .customLocation(let viewModel):
                CustomLocationView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    let appCoordinator = AppCoordinator(dependencies: AppContainer())
    return PlacesRootView(coordinator: appCoordinator.placesCoordinator)
}
