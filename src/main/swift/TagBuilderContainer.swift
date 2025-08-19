////
////  TagBuilderContainer.swift
////  autosave
////
////  Created by Asia Serrano on 8/15/25.
////
//
//import Foundation
//
//public struct InputsSortedMap: MapLike {
//    public typealias K = InputEnum
//    public typealias V = StringBuilders
//    public typealias Keys = SortedSet<K>
//    public typealias Index = Keys.Index      // <- required
//
//    public private(set) var keys: Keys
//    private var map: [K: V]
//    public private(set) var builders: TagBuilders
//
//    public init() {
//        self.keys = .init()
//        self.map = [:]
//        self.builders = .init()
//    }
//
//    // ExpressibleByDictionaryLiteral
//    public init(dictionaryLiteral elements: (K, V)...) {
//        self.init()
//        for (k, v) in elements { self[k] = v }    // funnel through keyed subscript
//    }
//
//    // Collection requirement: Element == (K, V)
//    public subscript(position: Index) -> (K, V) {
//        let key = keys[position]
//        return (key, self[key] ?? .defaultValue)
//    }
//
//    public func index(after i: Index) -> Index { keys.index(after: i) }
//    public var startIndex: Index { keys.startIndex }
//    public var endIndex: Index { keys.endIndex }
//
//    // MapLike keyed subscript
//    public subscript(_ key: K) -> V? {
//        get { map[key] }
//        set {
//            // choose your emptiness test; adjust to your API (isNotEmpty/isOccupied)
//            if let v = newValue, v.isOccupied {
//                keys += key
//                map[key] = v
//                // update builders if needed...
//            } else {
//                keys -= key
//                map[key] = nil
//                // update builders if needed...
//            }
//        }
//    }
//}
//
//
//
//public protocol MapLike: Hashable, Defaultable, Collection, Quantifiable, ExpressibleByDictionaryLiteral where Element == (K, V), Index == Keys.Index {
//    associatedtype K: Enumerable
//    associatedtype V: Hashable & Defaultable
//    
//    typealias Keys = SortedSet<K>
//    
//    var keys: Keys { get }
//    
//    subscript(_ key: Key) -> Value? { get set }  // key lookup/update
//}
//
//extension MapLike {
//    
//    public static var defaultValue: Self { .init() }
//    
//    public func hash(into hasher: inout Hasher) {
//        self.forEach {
//            hasher.combine("\($0.0.hashValue)|\($0.1.hashValue)")
//        }
//    }
//    
//    public func index(after i: Index) -> Index {
//        self.keys.index(after: i)
//    }
//    
//    public var startIndex: Index {
//        self.keys.startIndex
//    }
//    
//    public var endIndex: Index {
//        self.keys.endIndex
//    }
//    
//    public var quantity: Int {
//        self.keys.quantity
//    }
//    
//}
//
//
//public protocol NewSortedMapProtocol: Hashable, Defaultable, Quantifiable, RandomAccessCollection where Index == Keys.Index, Element: SortedMapElementProtocol, Element.K == K, Element.V == V {
//    associatedtype K: Enumerable
//    associatedtype V: Hashable & Defaultable
//    associatedtype Keys: SortedSetProtocol where Keys.Element == K
//    
//    var keys: Keys { get }
//    
//    init()
//    
//    func get(_ key: K, _ v: V) -> Element
//}
//
//extension NewSortedMapProtocol {
//
//    public static var defaultValue: Self { .init() }
//    
//    public func hash(into hasher: inout Hasher) {
//        self.forEach { hasher.combine($0) }
//    }
//    
//    public func index(after i: Index) -> Index {
//        self.keys.index(after: i)
//    }
//    
//    public var startIndex: Index {
//        self.keys.startIndex
//    }
//    
//    public var endIndex: Index {
//        self.keys.endIndex
//    }
//    
//    public var quantity: Int {
//        self.keys.quantity
//    }
//    
//    public func get(_ k: K, _ v: V) -> Element {
//        .init(k, v)
//    }
//    
//}
//
//
///*
// public struct InputsSortedMap: SortedMapProtocol {
//     
//     public typealias K = InputEnum
//     public typealias V = StringBuilders
//     public typealias Keys = SortedSet<K>
//     public typealias Index = Keys.Index
//     
//     public private(set) var keys: Keys
//     public private(set) var builders: TagBuilders
//     private var map: [K: V]
//     
//     public init() {
//         self.keys = .init()
//         self.map = .init()
//         self.builders = .init()
//     }
//     
// }
//
// public extension InputsSortedMap {
//     
//     static var random: Self {
//         var new: Self = .defaultValue
//         K.cases.forEach {
//             new[$0] = .random(2..<5)
//         }
//         return new
//     }
//     
//     
//     static func +=(lhs: inout Self, rhs: InputBuilder) -> Void {
//         let key: K = rhs.type
//         lhs[key] = lhs.get(key) + rhs.stringBuilder
//     }
//     
//     static func -=(lhs: inout Self, rhs: InputBuilder) -> Void {
//         let key: K = rhs.type
//         lhs[key] = lhs.get(key) - rhs.stringBuilder
//     }
//     
//     static func + (lhs: Self, rhs: (K, String)) -> Self {
//         let key: K = rhs.0
//         var new: Self = lhs
//         new[key] = new.get(key) + .string(rhs.1)
//         return new
//     }
//     
//     struct Element: SortedMapElementProtocol {
//         public let key: K
//         public let value: V
//         
//         public init(_ key: K, _ value: V) {
//             self.key = key
//             self.value = value
//         }
//         
//         public var builders: TagBuilders {
//             .init(self.value.map { .input(.init(self.key, $0)) })
//         }
//     }
//
//     subscript(key: K) -> V? {
//         get {
//             self.map[key]
//         }
//         set {
//             
//             if let old: V = self.map[key] {
//                 let element: Element = .init(key, old)
//                 self.builders -= element.builders
//             }
//             
//             if let value: V = newValue, value.isOccupied {
//                 self.keys += key
//                 self.map[key] = value
//                 
//                 let element: Element = .init(key, value)
//                 self.builders += element.builders
//                 
//             } else {
//                 self.keys -= key
//                 self.map[key] = nil
//             }
//         }
//     }
//
// }
// */
