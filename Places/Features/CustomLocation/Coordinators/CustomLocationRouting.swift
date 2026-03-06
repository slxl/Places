//
//  CustomLocationRouting.swift
//  Places
//

enum CustomLocationRouteTrigger {
    case dismiss
}

protocol CustomLocationRouting {
    func trigger(_ route: CustomLocationRouteTrigger)
}

protocol CustomLocationSaving: AnyObject {
    func addCustomLocation(lat: Double, lon: Double, name: String)
}
