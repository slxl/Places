//
//  CustomLocationViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
final class CustomLocationViewModel {
    var latText = ""
    var lonText = ""
    var nameText = ""
    var errorMessage: String?

    private weak var saver: CustomLocationSaving?
    private let router: CustomLocationRouting

    init(saver: CustomLocationSaving?, router: CustomLocationRouting) {
        self.saver = saver
        self.router = router
    }

    func cancel() {
        router.trigger(.dismiss)
    }

    func save() {
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
        saver?.addCustomLocation(lat: lat, lon: lon, name: name)
        router.trigger(.dismiss)
    }
}
