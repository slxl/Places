//
//  CustomCoordinatesViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
final class CustomCoordinatesViewModel {
    var latText = ""
    var lonText = ""
    var nameText = ""
    var errorMessage: String?

    private let onSave: (Double, Double, String) -> Void

    init(onSave: @escaping (Double, Double, String) -> Void) {
        self.onSave = onSave
    }

    /// Validates inputs, calls `onSave` if valid. Returns `true` if saved (caller should dismiss).
    func save() -> Bool {
        errorMessage = nil
        guard let lat = Double(latText.trimmingCharacters(in: .whitespaces)),
              lat >= -90, lat <= 90 else {
            errorMessage = "Enter a valid latitude (-90 to 90)."
            return false
        }
        guard let lon = Double(lonText.trimmingCharacters(in: .whitespaces)),
              lon >= -180, lon <= 180 else {
            errorMessage = "Enter a valid longitude (-180 to 180)."
            return false
        }
        let name = nameText.trimmingCharacters(in: .whitespaces)
        onSave(lat, lon, name)
        return true
    }
}
