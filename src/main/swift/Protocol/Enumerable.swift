//
//  Enumerable.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public protocol Enumerable: Identifiable, Hashable, Comparable, Equatable, CaseIterable, Iterable {
    var id: String { get }
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
    
    var description: String {
        String(describing: self)
    }
    
    var id: String { "\(self.index)_\(self.description)" }
        
    var rawValue: String { self.description.capitalized }
    
    var className: String { String(describing: Self.self) }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.className)
    }
    
    init(_ string: String) {
        if let found: Self = Self.cases.first(where: { $0.id == string || $0.rawValue == string }) {
            self = found
        } else {
            fatalError("Unable to parse key: \(string)")
        }
    }
    
    init(_ enumerable: any Enumerable) {
        self.init(enumerable.id)
    }
     
}
