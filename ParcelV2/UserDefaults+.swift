//
//  UserDefaults+.swift
//  ParcelV2
//
//  Created by Milkyo on 6/24/23.
//

import Foundation
extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.seokho.parcel"
        return UserDefaults(suiteName: appGroupId)!
    }
}
