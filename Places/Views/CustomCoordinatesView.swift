//
//  CustomCoordinatesView.swift
//  Places
//

import SwiftUI

struct CustomCoordinatesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var latText = ""
    @State private var lonText = ""
    @State private var nameText = ""
    @State private var errorMessage: String?

    let wikipediaRouter: WikipediaRouter

    var body: some View {
        NavigationStack {
            Form {
                Section("Coordinates") {
                    TextField("Latitude (-90 … 90)", text: $latText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Latitude")
                        .accessibilityHint("Enter latitude between minus 90 and 90")
                    TextField("Longitude (-180 … 180)", text: $lonText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Longitude")
                        .accessibilityHint("Enter longitude between minus 180 and 180")
                }
                Section("Name (optional)") {
                    TextField("Place name", text: $nameText)
                        .accessibilityLabel("Place name")
                        .accessibilityHint("Optional name for the location")
                }
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .dynamicTypeSize(DynamicTypeSize.accessibility1 ... DynamicTypeSize.accessibility3)
                            .accessibilityAddTraits(.isStaticText)
                            .accessibilityLabel("Validation error")
                            .accessibilityValue(errorMessage)
                    }
                }
            }
            .navigationTitle("Custom location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Closes custom location without opening Wikipedia")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Open in Wikipedia") {
                        openInWikipedia()
                    }
                    .accessibilityLabel("Open in Wikipedia")
                    .accessibilityHint("Opens the entered coordinates in the Wikipedia app")
                }
            }
        }
    }

    private func openInWikipedia() {
        errorMessage = nil
        guard let lat = Double(latText.trimmingCharacters(in: .whitespaces)),
              lat >= -90, lat <= 90 else {
            errorMessage = "Enter a valid latitude (-90 to 90)."
            return
        }
        guard let lon = Double(lonText.trimmingCharacters(in: .whitespaces)),
              lon >= -180, lon <= 180 else {
            errorMessage = "Enter a valid longitude (-180 to 180)."
            return
        }
        let name = nameText.trimmingCharacters(in: .whitespaces)
        wikipediaRouter.openPlaces(lat: lat, lon: lon, name: name.isEmpty ? nil : name)
        dismiss()
    }
}

#Preview {
    CustomCoordinatesView(wikipediaRouter: WikipediaRouter())
}
