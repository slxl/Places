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
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                            Text("\(formatCoord(location.lat)), \(formatCoord(location.lon))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                            .foregroundStyle(.secondary)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(location.name), \(formatCoord(location.lat)), \(formatCoord(location.lon))")
                .accessibilityHint("Opens this place in Wikipedia app")
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Custom") {
                        coordinator.showCustomLocation()
                    }
                    .accessibilityLabel("Custom location")
                    .accessibilityHint("Enter your own coordinates to open in Wikipedia")
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
