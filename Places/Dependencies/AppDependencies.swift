//
//  AppDependencies.swift
//  Places
//

import Foundation

protocol AppDependencies {
    var locationService: LocationService { get }
    var wikipediaRouter: WikipediaRouter { get }
}
