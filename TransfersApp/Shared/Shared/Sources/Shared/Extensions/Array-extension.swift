//
//  Array-extension.swift
//  Shared
//
//  Created by AREM on 10/31/25.
//

public extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
