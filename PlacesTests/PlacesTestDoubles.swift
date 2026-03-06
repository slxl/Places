import Foundation
import XCTest
@testable import Places

@MainActor
final class RecordingPlacesRouter: PlacesNavigationRouting {
    var listRoutes: [PlacesListRouteTrigger] = []

    func trigger(_ route: PlacesListRouteTrigger) {
        listRoutes.append(route)
    }
}

struct TestPlacesRouter: PlacesNavigationRouting {
    func trigger(_ route: PlacesListRouteTrigger) {}
}

struct RemoteLocationsLoader: PlacesLocationsLoading {
    let url: URL
    let session: URLSession

    func fetchAllLocations() async throws -> [Location] {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Location].self, from: data)
    }
}

final class StubURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    static var requestError: Error?
    static var responseDelay: TimeInterval = 0

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let execute = {
            if let error = Self.requestError {
                self.client?.urlProtocol(self, didFailWithError: error)
                return
            }

            guard let handler = Self.requestHandler else {
                self.client?.urlProtocol(self, didFailWithError: URLError(.badURL))
                return
            }

            do {
                let (response, data) = try handler(self.request)
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            } catch {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }

        if Self.responseDelay > 0 {
            DispatchQueue.global().asyncAfter(deadline: .now() + Self.responseDelay, execute: execute)
        } else {
            execute()
        }
    }

    override func stopLoading() {}
}
