//
//  TagGroup.swift
//  autosave
//
//  Created by Asia Serrano on 8/14/25.
//

import Foundation

public protocol TagGroupProtocol: Hashable, Defaultable, Quantifiable, RandomAccessCollection where Index == Keys.Index {
    associatedtype K: Enumerable
    associatedtype Keys: SortedSetProtocol where Keys.Element == K

    var keys: Keys { get }

    subscript(key: K) -> Element? { get set }

    init()

    func get(_ key: K) -> Element
}

public struct TagGroup: TagGroupProtocol {
    
    static func +=(lhs: inout Self, rhs: Element) -> Void {
        lhs[rhs.key] = rhs
    }
    
    public enum Key: Enumerable {
        case inputs
        case modes
        case platforms
    }
    
    public enum Element: Quantifiable {
        case inputs(Inputs)
        case modes(Modes)
        case platforms(Platforms)

        public var key: Key {
            switch self {
            case .inputs:
                return .inputs
            case .modes:
                return .modes
            case .platforms:
                return .platforms
            }
        }
        
        public var quantity: Int {
            switch self {
            case .inputs(let inputs):
                return inputs.count
            case .modes(let modes):
                return modes.count
            case .platforms(let platforms):
                return platforms.count
            }
        }

    }

    public typealias K = Key
    public typealias Keys = SortedSet<K>
    public typealias Index = Keys.Index
    
    private var inputs: Inputs
    private var modes: Modes
    private var platforms: Platforms
    
    public init() {
        self.inputs = .defaultValue
        self.modes = .defaultValue
        self.platforms = .defaultValue
    }
    
    public var quantity: Int {
        self.builders.count
    }
    
    public var keys: SortedSet<K> {
        .init(K.cases.filter { self[$0] != nil })
    }
    
    public subscript(index: Index) -> Element {
        get {
            switch K.cases[index] {
            case .inputs:
                return .inputs(self.inputs)
            case .modes:
                return .modes(self.modes)
            case .platforms:
                return .platforms(self.platforms)
            }
        }
    }
    
    public subscript(key: K) -> Element? {
        get {
            let element: Element = self.get(key)
            return element.isVacant ? nil : element
        }
        set {
            if let newValue: Element = newValue {
                switch newValue {
                case .inputs(let i):
                    self.inputs = i
                case .modes(let m):
                    self.modes = m
                case .platforms(let p):
                    self.platforms = p
                }
            }
        }
    }
    
    public func get(_ key: K) -> Element {
        switch key {
        case .inputs:
            return .inputs(self.inputs)
        case .modes:
            return .modes(self.modes)
        case .platforms:
            return .platforms(self.platforms)
        }
    }
    
    public var startIndex: Index {
        K.cases.startIndex
    }
    
    public var endIndex: Index {
        K.cases.endIndex
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.builders)
    }
    
}

extension TagGroup {
    
    public static var defaultValue: Self { .init() }
    
}

private extension TagGroup {
    
    var builders: TagBuilders {
        self.inputs.builders + self.modes.builders + self.platforms.builders
    }
    
}

fileprivate extension Inputs {
    
    var builders: TagBuilders {
        .init(self.flatMap { element in
            element.value.map { stringBuilder in
                let input: InputBuilder = .init(element.key, stringBuilder)
                return .input(input)
            }
        })
    }
    
}

fileprivate extension Formats {
    
    func builders(_ system: SystemBuilder) -> TagBuilders {
        .init(self.flatMap { element in
            element.value.map { format in
                let platform: PlatformBuilder = .init(system, format)
                return .platform(platform)
            }
        })
    }
    
}

fileprivate extension Systems {
    
    var builders: TagBuilders {
        .init(self.flatMap { element in
            element.value.builders(element.key)
        })
    }
    
}

fileprivate extension Platforms {
    
    var builders: TagBuilders {
        .init(self.flatMap(\.value.builders))
    }
    
}
