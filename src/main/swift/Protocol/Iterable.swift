//
//  Iterable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public protocol Iterable {
    static var cases: [Self] { get }
}

extension Iterable where Self: Equatable {
    
    public var index: Int {
        Self.cases.firstIndex(of: self) ?? -1
    }

    public var toggle: Self {
        let value: Int = index + 1
        let next: Int = value == Self.cases.count ? 0 : value
        return Self.cases[next]
    }
    
}
