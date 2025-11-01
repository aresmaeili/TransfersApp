//
//  UserDefaultTransfers.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//
import Foundation

// MARK: - UserDefaultTransfers
@propertyWrapper
struct UserDefaultTransfers {
    private let key = "savedTransfers"
    private let userDefaults = UserDefaults.standard
    
    var wrappedValue: [Transfer] {
        get {
            guard let data = userDefaults.data(forKey: key) else { return [] }
            let transfers: [Transfer] = (try? JSONDecoder().decode([Transfer].self, from: data)) ?? []
            return transfers
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
