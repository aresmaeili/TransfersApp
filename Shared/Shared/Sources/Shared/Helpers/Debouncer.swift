//
//  Debouncer.swift
//  Shared
//
//  Created by AREM on 11/13/25.
//

import Foundation

public final class Debouncer {
    private var delay: TimeInterval
    private var workItem: DispatchWorkItem?

    public init(delay: TimeInterval) {
        self.delay = delay
    }

    public func schedule(_ block: @escaping () -> Void) {
        workItem?.cancel()

        let item = DispatchWorkItem(block: block)
        workItem = item

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    public func cancel() {
        workItem?.cancel()
    }
}
