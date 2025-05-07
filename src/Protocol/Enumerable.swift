//
//  Enumerable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public protocol Enumerable: Identifiable, Hashable, Comparable, Equatable, CaseIterable, Iterable {
    var rawValue: String { get }
}

public extension Enumerable {
    
    static var random: Self {
        if let element: Self = Self.cases.randomElement() {
            return element
        } else {
            fatalError("unable to random element for \(Self.self)")
        }
    }
    
    static var defaultValue: Self {
        Self.cases.first!
    }
    
    static var cases: [Self] {
        Self.allCases.map { $0 }
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.index < rhs.index
    }
    
    var id: String { String(describing: self) }
        
    var rawValue: String { self.id.capitalized }
    
    var className: String { String(describing: Self.self) }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.className)
    }
    
    
//    static func cast(_ string: String) -> Self? {
//        if let enumerable: Self = Self.cases.first(where: { $0.id == string || $0.display == string }) {
//            return enumerable
//        } else {
//            return nil
//        }
//    }
//
//    static func cast(_ other: any Enumerable) -> Self? {
//        Self.cast(other.id)
//    }
    
    
    
//    init(_ other: any Enumerable) {
//        if let found: Self = .cast(other) {
//            self = found
//        } else {
//            fatalError("Unable to parse enumerable: \(other)")
//        }
//    }
//    
//    init(_ id: String) {
//        if let found: Self = .cast(id) {
//            self = found
//        } else {
//            fatalError("Unable to parse key: \(id)")
//        }
//    }
    
}
