//
//  PlacesLocationsLoading.swift
//  Places
//

protocol PlacesLocationsLoading {
    func fetchAllLocations() async throws -> [Location]
}
