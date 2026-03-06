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

    var body: some View {
        NavigationStack {
            Form {
                Section("Coordinates") {
                    TextField("Latitude (-90 … 90)", text: $latText)
                        .keyboardType(.decimalPad)
                    TextField("Longitude (-180 … 180)", text: $lonText)
                        .keyboardType(.decimalPad)
                }
                Section("Name (optional)") {
                    TextField("Place name", text: $nameText)
                }
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
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
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Open in Wikipedia") {
                        openInWikipedia()
                    }
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
        guard let url = WikipediaURL.placesURL(lat: lat, lon: lon, name: name.isEmpty ? nil : name) else {
            errorMessage = "Could not build URL."
            return
        }
        UIApplication.shared.open(url)
        dismiss()
    }
}

#Preview {
    CustomCoordinatesView()
}
