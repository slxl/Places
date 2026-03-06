//
//  PlacesListViewModel.swift
//  Places
//

import Foundation
import Observation

@Observable
final class PlacesListViewModel {
    private(set) var locations: [Location]
    private(set) var loadingState: PlacesListLoadingState = .idle

    private let locationService: LocationService
    private let loader: PlacesLocationsLoading
    private let router: PlacesNavigationRouting

    init(
        locationService: LocationService,
        router: PlacesNavigationRouting,
        loader: PlacesLocationsLoading? = nil
    ) {
        self.locationService = locationService
        self.loader = loader ?? locationService
        self.router = router
        self.locations = locationService.loadAllLocations()
        self.loadingState = locations.isEmpty ? .empty : .success
    }

    func openLocation(_ location: Location) {
        router.trigger(.openWikipediaPlaces(lat: location.lat, lon: location.lon, name: location.name))
    }

    func showCustomLocation() {
        router.trigger(.showCustomLocation)
    }

    func addCustomLocation(lat: Double, lon: Double, name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = trimmed.isEmpty ? "\(lat), \(lon)" : trimmed
        let location = Location(
            name: displayName,
            lat: lat,
            lon: lon,
            customId: UUID().uuidString
        )
        locationService.saveCustomLocation(location)
        locations = locationService.loadAllLocations()
        loadingState = locations.isEmpty ? .empty : .success
    }

    @MainActor
    func load() async {
        loadingState = .loading
        do {
            let loaded = try await loader.fetchAllLocations()
            locations = loaded
            loadingState = loaded.isEmpty ? .empty : .success
        } catch {
            loadingState = .failure(error.localizedDescription)
            locations = []
        }
    }
}

extension PlacesListViewModel: CustomLocationSaving {}
