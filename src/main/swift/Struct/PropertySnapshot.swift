////
////  PropertySnapshot.swift
////  autosave
////
////  Created by Asia Serrano on 5/9/25.
////
//
//import Foundation
//
//public struct PropertySnapshot: Uuidentifiable {
//    
////    public static func fromBuilder(_ builder: PropertyBuilder, _ uuid: UUID = .init()) -> Self {
////        let base: PropertyBase = builder.base
////        let string: StringBuilder = .fromPropertyBuilder(builder)
////        return .init(uuid, base, string)
////    }
////    
////    public static func random(_ base: PropertyBase) -> Self {
////        let builder: PropertyBuilder = .random(base)
////        let string: StringBuilder = builder.stringBuilder
////        return .init(.init(), base, string)
////    }
////    
////    public static var random: Self {
////        .random(.random)
////    }
////    
////    public static func fromModel(_ model: PropertyModel) -> Self {
////        let uuid: UUID = model.uuid
////        let base: PropertyBase = .init(model.type_id)
////        let string: StringBuilder = .fromPropertyModel(model)
////        return .init(uuid, base, string)
////    }
// 
//    public let uuid: UUID
//    public let builder: PropertyBuilder
//    
//    private init(_ uuid: UUID, _ base: PropertyBase, _ string: StringBuilder) {
//        self.uuid = uuid
//        self.base = base
//        self.string = string
//    }
//
//    public var type_id: String {
//        self.base.id
//    }
//    
//    public var value_canon: String {
//        self.string.canon
//    }
//    
//    public var value_trim: String {
//        self.string.trim
//    }
//    
//}
//
//extension PropertySnapshot: Hashable {
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.hashValue == rhs.hashValue
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.type_id)
//        hasher.combine(self.value_canon)
//        hasher.combine(self.value_trim)
//    }
//    
//}
