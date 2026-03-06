//
//  PlacesEmptyStateView.swift
//  Places
//

import SwiftUI

struct PlacesEmptyStateView: View {
    let onAddCustom: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mappin.slash.circle.fill")
                .font(.system(size: 54))
                .foregroundStyle(.tertiary)
            Text("No places yet")
                .font(.title3.weight(.semibold))
            Text("Add your first custom location to start browsing nearby articles in Wikipedia.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(action: onAddCustom) {
                Label("Add location", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
