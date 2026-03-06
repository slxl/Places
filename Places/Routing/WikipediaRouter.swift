//
//  WikipediaRouter.swift
//  Places
//

import Foundation
import UIKit

struct WikipediaRouter {
    func openPlaces(lat: Double, lon: Double, name: String?) {
        guard let url = WikipediaURL.placesURL(lat: lat, lon: lon, name: name) else { return }
        UIApplication.shared.open(url)
    }
}
