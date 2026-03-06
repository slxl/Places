import Foundation
import XCTest
@testable import Places

final class LocationServiceTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private var key: String!
    private var service: LocationService!

    override func setUp() {
        super.setUp()
        suiteName = "LocationServiceTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
        key = "customLocations.\(UUID().uuidString)"
        service = LocationService(defaults: defaults, customLocationsKey: key)
    }

    override func tearDown() {
        if let suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        suiteName = nil
        defaults = nil
        key = nil
        service = nil
        super.tearDown()
    }

    func testSaveCustomLocationPersistsToLoadAllLocations() {
        let location = Location(
            name: "Custom A",
            lat: 10.0,
            lon: 20.0,
            customId: "custom-a"
        )

        service.saveCustomLocation(location)
        let loaded = service.loadAllLocations()

        XCTAssertTrue(loaded.contains(where: { $0.id == "custom-a" }))
    }

    func testSaveCustomLocationMergesByIdAndReplacesOldValue() {
        let old = Location(
            name: "Old Name",
            lat: 1.0,
            lon: 2.0,
            customId: "same-id"
        )
        let replacement = Location(
            name: "New Name",
            lat: 3.0,
            lon: 4.0,
            customId: "same-id"
        )

        service.saveCustomLocation(old)
        service.saveCustomLocation(replacement)
        let loaded = service.loadAllLocations().filter { $0.id == "same-id" }

        XCTAssertEqual(loaded.count, 1)
        guard let item = loaded.first else {
            return XCTFail("Expected merged item")
        }
        XCTAssertEqual(item.name, "New Name")
        XCTAssertEqual(item.lat, 3.0, accuracy: 0.0001)
        XCTAssertEqual(item.lon, 4.0, accuracy: 0.0001)
    }
}
