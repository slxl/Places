//
//  PlacesListRouter.swift
//  Places
//

import UIKit

final class PlacesListRouter: PlacesNavigationRouting {
    weak var coordinator: PlacesListRouteCoordinating?

    func trigger(_ route: PlacesListRouteTrigger) {
        switch route {
        case .showCustomLocation:
            coordinator?.coordinate(route)
        case .openWikipediaPlaces(let lat, let lon, let name):
            guard let url = WikipediaURL.placesURL(lat: lat, lon: lon, name: name) else { return }
            UIApplication.shared.open(url)
        }
    }

}
