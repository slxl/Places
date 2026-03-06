//
//  PlacesListLoadingState.swift
//  Places
//

enum PlacesListLoadingState: Equatable {
    case idle
    case loading
    case success
    case empty
    case failure(String)
}
