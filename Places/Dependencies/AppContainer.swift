//
//  AppContainer.swift
//  Places
//

import Foundation

struct AppContainer: AppDependencies {
    var locationService: LocationService { LocationService() }
    var wikipediaRouter: WikipediaRouter { WikipediaRouter() }
}
