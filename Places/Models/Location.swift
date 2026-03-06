//
//  Location.swift
//  Places
//

import Foundation

struct Location: Codable, Identifiable {
    var id: String { "\(lat)-\(lon)" }
    let name: String
    let lat: Double
    let lon: Double
}
