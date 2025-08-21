//
//  Dictionary.swift
//  autosave
//
//  Created by Asia Serrano on 6/21/25.
//

import Foundation

extension Dictionary: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension Dictionary: Quantifiable {
    
    public var quantity: Int { self.count }
    
}

extension Dictionary where Value: Quantifiable & Defaultable {
    
    public static func -->(lhs: inout Self, rhs: (Value?, Key)) -> Void {
        let value: Value = rhs.0 ?? .defaultValue
        lhs[rhs.1] = value.isVacant ? nil : value
    }
    
    public static func -->(lhs: Self, rhs: Element) -> Self {
        var new: Self = lhs
        new --> (rhs.value, rhs.key)
        return new
    }
    
}


//extension Dictionary where Value: Defaultable {
//
//    public func get(_ key: Key) -> Value {
//        self[key] ?? .defaultValue
//    }
//
//}


//extension Dictionary where Value: Quantifiable {
//    
////    public static func -->(lhs: inout Self, rhs: Element) -> Void {
////        let value: Value = rhs.value
////        lhs[rhs.key] = value.isVacant ? nil : value
////    }
//    
////    public static func -->(lhs: Self, rhs: (Value, Key)) -> Self {
////        var new: Self = lhs
////        new --> (rhs.1, rhs.0)
////        return new
////    }
//    
//    public static func -=(lhs: inout Self, rhs: Key) -> Void {
//        lhs[rhs] = nil
//    }
//    
//    public static func -(lhs: Self, rhs: Key) -> Self {
//        var new: Self = lhs
//        new -= rhs
//        return new
//    }
//    
//}

//extension Dictionary where Value: TagsSortedSetProtocol {
//    
//    public typealias SubElement = (Key, Value.Element)
//    
//    public static func +=(lhs: inout Self, rhs: SubElement) -> Void {
//        let key: Key = rhs.0
//        let value: Value? = lhs.get(key) + rhs.1
//        lhs --> (key, value)
//    }
//    
//    public static func -=(lhs: inout Self, rhs: SubElement) -> Void {
//        let key: Key = rhs.0
//        let value: Value? = lhs.get(key) - rhs.1
//        lhs --> (key, value)
//    }
//    
//    public static func +(lhs: Self, rhs: SubElement) -> Self {
//        var new: Self = lhs
//        new += rhs
//        return new
//    }
//    
//    public static func -(lhs: Self, rhs: SubElement) -> Self {
//        var new: Self = lhs
//        new -= rhs
//        return new
//    }
//    
//    public var builders: TagBuilders {
//        .init(self.values.flatMap { $0.builders })
//    }
//    
//}


//extension Dictionary where Value: TagsSortedSetProtocol {
//    
//    public typealias SubElement2 = (Key, Value.Element)
//    
//    public static func +=(lhs: inout Self, rhs: SubElement2) -> Void {
//        let key: Key = rhs.0
//        let value: Value = lhs.get(key) + rhs.1
//        lhs --> (key, value)
//    }
//    
//    public static func -=(lhs: inout Self, rhs: SubElement2) -> Void {
//        let key: Key = rhs.0
//        let value: Value = lhs.get(key) - rhs.1
//        lhs --> (key, value)
//    }
//    
//    public static func +(lhs: Self, rhs: SubElement2) -> Self {
//        var new: Self = lhs
//        new += rhs
//        return new
//    }
//    
//    public static func -(lhs: Self, rhs: SubElement2) -> Self {
//        var new: Self = lhs
//        new -= rhs
//        return new
//    }
//    
//}
