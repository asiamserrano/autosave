//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary where Key: Enumerable, Value: ExpressibleByArrayLiteral {
    
    public var keys: [Key] {
        Key.cases.filter { self[$0] != nil }.sorted()
    }
    
    public func getOrDefault(_ key: Key) -> Value {
        self[key] ?? []
    }
    
}

extension Tags.Modes {
    
    public static var random: Self {
        .init(uniqueKeysWithValues: ModeEnum.cases.map { ($0, .random()) })
    }
    
    public init() {
        self = .init(uniqueKeysWithValues: ModeEnum.cases.map { ($0, false) })
    }
    
    public var modeEnums: [Key] {
        Key.cases.filter { self[$0] ?? false }.sorted()
    }
    
    public var isEmpty: Bool {
        self.values.isEmpty || self.values.allSatisfy { $0 == false }
    }
    
}

extension Tags.Inputs {
    
    public static var random: Self {
        .init(uniqueKeysWithValues: Key.cases.map { input in
            let size: Int = .random(in: 0..<3)
            let value: Value = .random(size)
            return (input, value)
        })
    }

    public func string(_ key: Key) -> String? {
        if let value: Value = self[key] {
            if value.isNotEmpty {
                return value.map { $0.trim }.sorted().joined(separator: "\n")
            }
        }
        return nil
    }
   
}

extension Tags.Platforms {
    
    public static var random: Self {
        let size: Int = .random(in: 0..<2)
        let platforms: Set<PlatformBuilder> = .init()
        var result: Self = .init()
        while platforms.count < size {
            let platform: PlatformBuilder = .random
            let key: Key = platform.system
            var set: Value = result.getOrDefault(key)
            set.insert(platform.format)
            result[key] = set
        }
        return result
    }

    public func array(_ key: Key) -> [Value.Element] {
        getOrDefault(key).sorted()
    }
    
}


//extension Dictionary where Key == InputEnum, Value == [String] {
//    
//    public var builders: [TagBuilder] {
//        self.sortedKeys.flatMap { key in
//            self.getOrDefault(key).map { value in
//                let input: InputBuilder = .init(key, value)
//                return .input(input)
//            }
//        }
//    }
//}
//
//extension Dictionary where Key == ModeEnum, Value == Bool {
//    
//    public var builders: [TagBuilder] {
//        self.keys.sorted().compactMap { key in
//            let value: Bool = self[key] ?? false
//            if value {
//                return .mode(key)
//            } else {
//                return nil
//            }
//        }
//    }
//    
//}

extension Dictionary where Key == SystemBuilder, Value == [FormatBuilder] {
    
    public init(_ builders: [PlatformBuilder]) {
        self = .init(uniqueKeysWithValues: builders.map { item in
            let system: SystemBuilder = item.system
            let formatBuilders = builders.filter(system)
            return (system, formatBuilders)
        })
    }

//    public var builders: [TagBuilder] {
//        self.sortedKeys.flatMap { key in
//            self.getOrDefault(key).map { value in
//                let platform: PlatformBuilder = .init(key, value)
//                return .platform(platform)
//            }
//        }
//    }
    
}


//public typealias TagDictionary = Dictionary<TagType, [TagBuilder]>
//
////extension Dictionary: Identifiable, Hashable {
//extension TagDictionary {
//
//    public init(_ relations: [RelationModel], _ properties: [PropertyModel]) {
//        self = .init(uniqueKeysWithValues: TagType.cases.compactMap { key in
//            let value: Value = .init(key, relations, properties)
//            return value.isEmpty ? nil : (key, value)
//        })
//    }
//    
//}
