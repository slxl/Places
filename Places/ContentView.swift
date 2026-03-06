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
                    Button {
                        coordinator.showCustomLocation()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Custom location")
                    .accessibilityHint("Add a custom location to the list")
                }
            }
            .sheet(item: $coordinator.presentedRoute, onDismiss: {
                coordinator.dismissRoute()
            }) { route in
                switch route {
                case .customLocation:
                    CustomCoordinatesView(onSave: { lat, lon, name in
                        coordinator.addCustomLocation(lat: lat, lon: lon, name: name)
                    })
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
