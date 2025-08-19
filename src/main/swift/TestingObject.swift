//
//  TestingObject.swift
//  autosave
//
//  Created by Asia Serrano on 8/4/25.
//

import Foundation
/*
public protocol MapQueryKey { associatedtype Output }

public struct InputKey: MapQueryKey {
    public typealias Output = [String]
    public let input: InputEnum
    public init(_ input: InputEnum) { self.input = input }
}

public struct ModesKey: MapQueryKey {
    public typealias Output = [ModeEnum]
    public init() {}
}

// Query a concrete leaf: (SystemEnum, SystemBuilder, FormatEnum) → [FormatBuilder]
public struct PlatformKey: MapQueryKey {
    public typealias Output = [FormatBuilder]
    public let system: SystemEnum
    public let builder: SystemBuilder
    public let format: FormatEnum
    public init(_ system: SystemEnum, _ builder: SystemBuilder, _ format: FormatEnum) {
        self.system = system; self.builder = builder; self.format = format
    }
}

// (Optional) convenience keys for intermediate queries:
public struct SystemBuildersKey: MapQueryKey {
    public typealias Output = [SystemBuilder]
    public let system: SystemEnum
    public init(_ system: SystemEnum) { self.system = system }
}

public struct FormatsKey: MapQueryKey {
    public typealias Output = [FormatEnum]
    public let system: SystemEnum
    public let builder: SystemBuilder
    public init(_ system: SystemEnum, _ builder: SystemBuilder) {
        self.system = system; self.builder = builder
    }
}

public struct CatalogMap {
    // Inputs and Modes unchanged...
    private var inputs: [InputEnum: [String]] = [:]
    private var modes: Set<ModeEnum> = []

    // Platform: SystemEnum → SystemBuilder → FormatEnum → [FormatBuilder]
    private var platforms: [SystemEnum: [SystemBuilder: [FormatEnum: [FormatBuilder]]]] = [:]

    public init() {}
}


public extension CatalogMap {
    // Inputs
    subscript(key: InputKey) -> [String] {
        get { inputs[key.input] ?? [] }
        set { inputs[key.input] = newValue.isEmpty ? nil : newValue }
    }

    // Modes
    subscript(key: ModesKey) -> [ModeEnum] {
        get { Array(modes).sorted() }
        set { modes = Set(newValue) }
    }

    // Platforms: leaf level
    subscript(key: PlatformKey) -> [FormatBuilder] {
        get { platforms[key.system]?[key.builder]?[key.format] ?? [] }
        set {
            if newValue.isEmpty {
                // delete leaf and clean up empty parents
                platforms[key.system]?[key.builder]?[key.format] = nil
                if platforms[key.system]?[key.builder]?.isEmpty == true {
                    platforms[key.system]?[key.builder] = nil
                }
                if platforms[key.system]?.isEmpty == true {
                    platforms[key.system] = nil
                }
            } else {
                platforms[key.system, default: [:]][key.builder, default: [:]][key.format] = newValue
            }
        }
    }

    // (Optional) intermediate queries
    subscript(key: SystemBuildersKey) -> [SystemBuilder] {
        get {
            if let systems = self.platforms[key.system] {
                return systems.keys.sorted()
            } else {
                return .defaultValue
            }
        }
        set {
            // if you want this to be writable, decide how to materialize empty builder buckets
            // simplest: ignore setter or clear
        }
    }

    subscript(key: FormatsKey) -> [FormatEnum] {
        get {
            if let systems = self.platforms[key.system] {
                if let formats = systems[key.builder] {
                    return formats.keys.sorted()
                }
            }
            return .defaultValue
        }
        set {
            // similar note as above; typically read-only
        }
    }
}

*/
