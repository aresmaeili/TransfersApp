//
//  UserDefaultTransfers.swift
//  TransferFeature
//
//  Created by AREM on 10/31/25.
//

import Foundation

// MARK: - UserDefaultTransfers

/// A property wrapper that stores and retrieves `[Transfer]` objects
/// from `UserDefaults` using JSON encoding.
@propertyWrapper
struct UserDefaultTransfers {
    
    // MARK: - Properties
    
    private let key: String
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    init(key: String = "savedTransfers", userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }
    
    // MARK: - Wrapped Value
    
    var wrappedValue: [Transfer] {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return []
            }
            
            do {
                return try JSONDecoder().decode([Transfer].self, from: data)
            } catch {
                print("⚠️ Failed to decode transfers from UserDefaults: \(error)")
                return []
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: key)
            } catch {
                print("⚠️ Failed to encode transfers to UserDefaults: \(error)")
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
