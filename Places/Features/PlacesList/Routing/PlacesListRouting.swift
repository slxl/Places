//
//  PlacesListRouting.swift
//  Places
//

enum PlacesListRouteTrigger {
    case showCustomLocation
    case openWikipediaPlaces(lat: Double, lon: Double, name: String?)
}

protocol PlacesListRouting {
    func trigger(_ route: PlacesListRouteTrigger)
}

protocol PlacesNavigationRouting: PlacesListRouting {}

protocol PlacesListRouteCoordinating: AnyObject {
    func coordinate(_ route: PlacesListRouteTrigger)
}
