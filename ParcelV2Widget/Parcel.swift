//
//  Parcel.swift
//  ParcelV2
//
//  Created by Milkyo on 6/24/23.
//

import Foundation

struct Parcel: Codable {
    struct Person: Codable {
        let name: String
        let time: String?
    }
    
    struct Status: Codable {
        let id: String
        let text: String
    }
    
    struct Location: Codable {
        let name: String
    }
    
    struct Progress: Codable {
        let time: String
        let status: Status
        let location: Location
        let description: String
    }
    
    let from: Person
    let to: Person
    let state: Status
    let item: String?
    let progresses: [Progress]
    let carrier: Carrier
    
    struct Carrier: Codable {
        let id: String
        let name: String
        let tel: String
    }
}

struct ProgressWrapper: Identifiable {
    static func == (lhs: ProgressWrapper, rhs: ProgressWrapper) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let time: String
    let status: Parcel.Status
    let location: Parcel.Location
    let description: String
}
extension ProgressWrapper: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
