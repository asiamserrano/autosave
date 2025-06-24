//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary where Key: Comparable, Value: ExpressibleByArrayLiteral {
    
    public var sortedKeys: [Key] {
        self.keys.sorted()
    }
    
    public func getOrDefault(_ key: Key) -> Value {
        self[key] ?? []
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
