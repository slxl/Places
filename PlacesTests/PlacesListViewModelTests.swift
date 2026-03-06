import Foundation
import XCTest
@testable import Places

@MainActor
final class PlacesListViewModelTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private var service: LocationService!
    private var key: String!

    override func setUp() {
        super.setUp()
        suiteName = "PlacesListViewModelTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
        key = "customLocations.\(UUID().uuidString)"
        service = LocationService(defaults: defaults, customLocationsKey: key)
        StubURLProtocol.requestHandler = nil
        StubURLProtocol.requestError = nil
        StubURLProtocol.responseDelay = 0
    }

    override func tearDown() {
        if let suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        suiteName = nil
        defaults = nil
        service = nil
        key = nil
        super.tearDown()
    }

    func testLoadTransitionsToLoadingThenSuccess() async throws {
        let url = URL(string: "https://example.test/locations")!
        StubURLProtocol.responseDelay = 0.2
        StubURLProtocol.requestHandler = { _ in
            let data = """
            [
              {"name":"Amsterdam","lat":52.37,"lon":4.90}
            ]
            """.data(using: .utf8)!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let viewModel = makeViewModel(url: url)
        let task = Task { await viewModel.load() }

        try? await Task.sleep(nanoseconds: 80_000_000)
        XCTAssertEqual(viewModel.loadingState, .loading)

        await task.value
        XCTAssertEqual(viewModel.loadingState, .success)
        XCTAssertEqual(viewModel.locations.count, 1)
        XCTAssertEqual(viewModel.locations.first?.name, "Amsterdam")
    }

    func testLoadTransitionsToEmptyForEmptyResponse() async {
        let url = URL(string: "https://example.test/locations-empty")!
        StubURLProtocol.requestHandler = { _ in
            let data = "[]".data(using: .utf8)!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        let viewModel = makeViewModel(url: url)
        await viewModel.load()

        XCTAssertEqual(viewModel.loadingState, .empty)
        XCTAssertTrue(viewModel.locations.isEmpty)
    }

    func testLoadTransitionsToFailureOnNetworkError() async {
        let url = URL(string: "https://example.test/failure")!
        StubURLProtocol.requestError = URLError(.notConnectedToInternet)

        let viewModel = makeViewModel(url: url)
        await viewModel.load()

        guard case .failure = viewModel.loadingState else {
            XCTFail("Expected failure state")
            return
        }
        XCTAssertTrue(viewModel.locations.isEmpty)
    }

    func testShowCustomLocationTriggersRouteIntent() async {
        let router = RecordingPlacesRouter()
        let viewModel = PlacesListViewModel(
            locationService: service,
            router: router
        )

        viewModel.showCustomLocation()
        await MainActor.run { }

        XCTAssertEqual(router.listRoutes.count, 1)
        guard case .showCustomLocation = router.listRoutes[0] else {
            return XCTFail("Expected .showCustomLocation route")
        }
    }

    func testOpenLocationTriggersWikipediaRouteIntent() async {
        let router = RecordingPlacesRouter()
        let viewModel = PlacesListViewModel(
            locationService: service,
            router: router
        )
        let location = Location(name: "Amsterdam", lat: 52.37, lon: 4.90)

        viewModel.openLocation(location)
        await MainActor.run { }

        XCTAssertEqual(router.listRoutes.count, 1)
        guard case let .openWikipediaPlaces(lat, lon, name) = router.listRoutes[0] else {
            return XCTFail("Expected .openWikipediaPlaces route")
        }
        XCTAssertEqual(lat, location.lat, accuracy: 0.0001)
        XCTAssertEqual(lon, location.lon, accuracy: 0.0001)
        XCTAssertEqual(name, location.name)
    }

    func testAddCustomLocationAppendsAndPersistsLocation() async {
        let viewModel = PlacesListViewModel(
            locationService: service,
            router: TestPlacesRouter()
        )
        let initialCount = viewModel.locations.count

        viewModel.addCustomLocation(lat: 52.37, lon: 4.90, name: "Amsterdam Custom")
        await MainActor.run { }

        XCTAssertEqual(viewModel.locations.count, initialCount + 1)
        guard let added = viewModel.locations.last else {
            return XCTFail("Expected added location")
        }
        XCTAssertEqual(added.name, "Amsterdam Custom")
        XCTAssertEqual(added.lat, 52.37, accuracy: 0.0001)
        XCTAssertEqual(added.lon, 4.90, accuracy: 0.0001)
        XCTAssertNotNil(added.customId)
        XCTAssertEqual(viewModel.loadingState, .success)
        XCTAssertTrue(service.loadAllLocations().contains(where: { $0.id == added.id }))
    }

    func testAddCustomLocationUsesFallbackNameWhenEmptyAfterTrim() async {
        let viewModel = PlacesListViewModel(
            locationService: service,
            router: TestPlacesRouter()
        )

        viewModel.addCustomLocation(lat: 1.0, lon: 2.0, name: "   \n ")
        await MainActor.run { }

        guard let added = viewModel.locations.last else {
            return XCTFail("Expected added location")
        }
        XCTAssertEqual(added.name, "1.0, 2.0")
    }

    private func makeViewModel(url: URL) -> PlacesListViewModel {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubURLProtocol.self]
        let session = URLSession(configuration: config)
        let loader = RemoteLocationsLoader(url: url, session: session)
        let router = TestPlacesRouter()
        return PlacesListViewModel(
            locationService: service,
            router: router,
            loader: loader
        )
    }
}
