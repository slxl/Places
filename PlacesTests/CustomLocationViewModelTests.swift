import XCTest
@testable import Places

@MainActor
final class CustomLocationViewModelTests: XCTestCase {
    func testCancelTriggersDismissRoute() async {
        let saver = RecordingCustomLocationSaver()
        let router = RecordingCustomLocationRouter()
        let viewModel = CustomLocationViewModel(saver: saver, router: router)

        viewModel.cancel()
        await MainActor.run { } // let router.trigger(.dismiss) complete on MainActor

        XCTAssertEqual(router.routes, [.dismiss])
        XCTAssertEqual(saver.callsCount, 0)
    }

    func testSaveWithInvalidLatitudeShowsErrorAndDoesNotDismiss() async {
        let saver = RecordingCustomLocationSaver()
        let router = RecordingCustomLocationRouter()
        let viewModel = CustomLocationViewModel(saver: saver, router: router)
        viewModel.latText = "999"
        viewModel.lonText = "20"
        viewModel.nameText = "Name"

        viewModel.save()
        await MainActor.run { }

        XCTAssertEqual(viewModel.errorMessage, "Enter a valid latitude (-90 to 90).")
        XCTAssertTrue(router.routes.isEmpty)
        XCTAssertEqual(saver.callsCount, 0)
    }

    func testSaveWithInvalidLongitudeShowsErrorAndDoesNotDismiss() async {
        let saver = RecordingCustomLocationSaver()
        let router = RecordingCustomLocationRouter()
        let viewModel = CustomLocationViewModel(saver: saver, router: router)
        viewModel.latText = "52.37"
        viewModel.lonText = "200"
        viewModel.nameText = "Name"

        viewModel.save()
        await MainActor.run { }

        XCTAssertEqual(viewModel.errorMessage, "Enter a valid longitude (-180 to 180).")
        XCTAssertTrue(router.routes.isEmpty)
        XCTAssertEqual(saver.callsCount, 0)
    }

    func testSaveWithValidInputPersistsAndDismisses() async {
        let saver = RecordingCustomLocationSaver()
        let router = RecordingCustomLocationRouter()
        let viewModel = CustomLocationViewModel(saver: saver, router: router)
        viewModel.latText = "52.37"
        viewModel.lonText = "4.90"
        viewModel.nameText = "  Amsterdam  "

        viewModel.save()
        await MainActor.run { }

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(saver.callsCount, 1)
        guard let call = saver.lastCall else {
            return XCTFail("Expected save call")
        }
        XCTAssertEqual(call.lat, 52.37, accuracy: 0.0001)
        XCTAssertEqual(call.lon, 4.90, accuracy: 0.0001)
        XCTAssertEqual(call.name, "Amsterdam")
        XCTAssertEqual(router.routes, [.dismiss])
    }
}

@MainActor
private final class RecordingCustomLocationSaver: CustomLocationSaving {
    private(set) var callsCount = 0
    private(set) var lastCall: (lat: Double, lon: Double, name: String)?

    func addCustomLocation(lat: Double, lon: Double, name: String) {
        callsCount += 1
        lastCall = (lat: lat, lon: lon, name: name)
    }
}

@MainActor
private final class RecordingCustomLocationRouter: CustomLocationRouting {
    private(set) var routes: [CustomLocationRouteTrigger] = []

    func trigger(_ route: CustomLocationRouteTrigger) {
        routes.append(route)
    }
}
