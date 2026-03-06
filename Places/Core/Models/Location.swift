//
//  Location.swift
//  Places
//

import Foundation

struct Location: Codable, Identifiable {
    var id: String { customId ?? "\(lat)-\(lon)" }
    let name: String
    let lat: Double
    let lon: Double
    /// Stable id for persisted custom locations (avoids duplicate keys when same lat/lon).
    let customId: String?

    init(name: String, lat: Double, lon: Double, customId: String? = nil) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.customId = customId
    }

    enum CodingKeys: String, CodingKey {
        case name, lat, lon, customId
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        name = try c.decode(String.self, forKey: .name)
        lat = try c.decode(Double.self, forKey: .lat)
        lon = try c.decode(Double.self, forKey: .lon)
        customId = try c.decodeIfPresent(String.self, forKey: .customId)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(lat, forKey: .lat)
        try c.encode(lon, forKey: .lon)
        try c.encodeIfPresent(customId, forKey: .customId)
    }
}
