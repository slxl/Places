//
//  ContentView.swift
//  Places
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = PlacesListViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            List(viewModel.locations) { location in
                Button {
                    viewModel.openLocation(location)
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
                        viewModel.presentCustomCoordinates()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showCustomCoordinates) {
                CustomCoordinatesView()
            }
        }
    }

    private func formatCoord(_ value: Double) -> String {
        String(format: "%.4f", value)
    }
}

#Preview {
    ContentView()
}
