//
//  PlacesFailureStateView.swift
//  Places
//

import SwiftUI

struct PlacesFailureStateView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 52))
                .foregroundStyle(.orange)
            Text("Could not load places")
                .font(.title3.weight(.semibold))
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .minimumScaleFactor(0.85)
                .padding(.horizontal)
            Button("Try again", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
