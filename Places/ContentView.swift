//
//  ContentView.swift
//  Places
//

import SwiftUI

struct ContentView: View {
    @State private var coordinator: PlacesCoordinator

    init(coordinator: PlacesCoordinator) {
        _coordinator = State(initialValue: coordinator)
    }

    var body: some View {
        @Bindable var coordinator = coordinator
        NavigationStack {
            List(coordinator.viewModel.locations) { location in
                Button {
                    coordinator.viewModel.openLocation(location)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name)
                                .font(.headline)
                            Text("\(formatCoord(location.lat)), \(formatCoord(location.lon))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Custom") {
                        coordinator.showCustomLocation()
                    }
                }
            }
            .sheet(item: $coordinator.presentedRoute, onDismiss: {
                coordinator.dismissRoute()
            }) { route in
                switch route {
                case .customLocation:
                    CustomCoordinatesView(wikipediaRouter: coordinator.wikipediaRouter)
                }
            }
        }
    }

    private func formatCoord(_ value: Double) -> String {
        String(format: "%.4f", value)
    }
}

#Preview {
    let appCoordinator = AppCoordinator(dependencies: AppContainer())
    return ContentView(coordinator: appCoordinator.placesCoordinator)
}
