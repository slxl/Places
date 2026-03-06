//
//  PlacesRoute.swift
//  Places
//

import Foundation

enum PlacesRoute: Identifiable {
    case customLocation(CustomLocationViewModel)

    var id: String {
        switch self {
        case .customLocation(let viewModel):
            return "customLocation-\(ObjectIdentifier(viewModel).hashValue)"
        }
    }
}
