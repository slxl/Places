//
//  PlacesListView.swift
//  Places
//

import SwiftUI

struct PlacesListView: View {
    @Bindable var viewModel: PlacesListViewModel

    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .idle, .loading:
                PlacesLoadingStateView()
            case .empty:
                PlacesEmptyStateView {
                    viewModel.showCustomLocation()
                }
            case .failure(let message):
                PlacesFailureStateView(message: message) {
                    Task {
                        await viewModel.load()
                    }
                }
            case .success:
                List(viewModel.locations) { location in
                    Button {
                        viewModel.openLocation(location)
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
            }
        }
        .navigationTitle("Places")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showCustomLocation()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Custom location")
                .accessibilityHint("Add a custom location to the list")
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private func formatCoord(_ value: Double) -> String {
        String(format: "%.4f", value)
    }
}

#Preview {
    let appCoordinator = AppCoordinator(dependencies: AppContainer())
    return PlacesListView(viewModel: appCoordinator.placesCoordinator.viewModel)
}
