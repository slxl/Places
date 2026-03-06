import Foundation
import XCTest
@testable import Places

@MainActor
final class PlacesCoordinatorTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private var service: LocationService!

    override func setUp() {
        super.setUp()
        suiteName = "PlacesCoordinatorTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
        service = LocationService(
            defaults: defaults,
            customLocationsKey: "customLocations.\(UUID().uuidString)"
        )
    }

    override func tearDown() {
        if let suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        suiteName = nil
        defaults = nil
        service = nil
        super.tearDown()
    }

    func testShowCustomLocationPresentsCustomLocationRoute() async {
        let coordinator = PlacesCoordinator(
            dependencies: AppContainer(locationService: service)
        )

        coordinator.coordinate(.showCustomLocation)
        await MainActor.run { } // flush main queue; avoid refcount/ordering races

        guard case .customLocation = coordinator.presentedRoute else {
            return XCTFail("Expected coordinator to present custom location route")
        }
    }

    func testCancelFromCustomLocationDismissesPresentedRoute() async {
        let coordinator = PlacesCoordinator(
            dependencies: AppContainer(locationService: service)
        )
        coordinator.coordinate(.showCustomLocation)

        guard case .customLocation(let viewModel) = coordinator.presentedRoute else {
            return XCTFail("Expected custom location route")
        }

        viewModel.cancel()
        await MainActor.run { } // allow deferred dismissPresentedRoute() to run

        XCTAssertNil(coordinator.presentedRoute)
    }

    func testSaveFromCustomLocationAddsLocationAndDismissesPresentedRoute() async {
        let coordinator = PlacesCoordinator(
            dependencies: AppContainer(locationService: service)
        )
        let initialCount = coordinator.viewModel.locations.count
        coordinator.coordinate(.showCustomLocation)

        guard case .customLocation(let viewModel) = coordinator.presentedRoute else {
            return XCTFail("Expected custom location route")
        }

        viewModel.latText = "52.37"
        viewModel.lonText = "4.90"
        viewModel.nameText = "Saved from custom flow"
        viewModel.save()
        await MainActor.run { } // allow deferred dismissPresentedRoute() to run

        XCTAssertNil(coordinator.presentedRoute)
        XCTAssertEqual(coordinator.viewModel.locations.count, initialCount + 1)
        XCTAssertTrue(coordinator.viewModel.locations.contains {
            $0.name == "Saved from custom flow"
        })
    }
}
