//
//  PlacesListViewModel.swift
//  Places
//

import Foundation
import Observation
import UIKit

@Observable
final class PlacesListViewModel {
    private(set) var locations: [Location]
    var showCustomCoordinates: Bool = false

    private let openURL: (URL) -> Void

    init(
        locations: [Location] = LocationsLoader.load(),
        openURL: @escaping (URL) -> Void = { UIApplication.shared.open($0) }
    ) {
        self.locations = locations
        self.openURL = openURL
    }

    func openLocation(_ location: Location) {
        guard let url = WikipediaURL.placesURL(lat: location.lat, lon: location.lon, name: location.name) else { return }
        openURL(url)
    }

    func presentCustomCoordinates() {
        showCustomCoordinates = true
    }
}
