//
//  PropertySnapshot.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct PropertySnapshot {
    
//    public static func fromBuilder(_ builder: PropertyBuilder) -> Self {
//        let type: PropertyEnum = builder.type
//        let string: StringBuilder = .fromPropertyBuilder(builder)
//        return .init(.init(), type, string)
//    }
    
    public static func random(_ type: PropertyEnum) -> Self {
        let property: PropertyBuilder = .random(type)
        let string: StringBuilder = property.stringBuilder
        return .init(.init(), type, string)
    }
    
    public static var random: Self {
        .random(.random)
    }
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let uuid: UUID = model.uuid
        let type: PropertyEnum = .init(model.type_id)
        let string: StringBuilder = .fromPropertyModel(model)
        return .init(uuid, type, string)
    }
 
    public let uuid: UUID
    public let type: PropertyEnum
    public let string: StringBuilder
    
    private init(_ uuid: UUID, _ type: PropertyEnum, _ string: StringBuilder) {
        self.uuid = uuid
        self.type = type
        self.string = string
    }

    public var type_id: String {
        self.type.id
    }
    
    public var value_canon: String {
        self.string.canon
    }
    
    public var value_trim: String {
        self.string.trim
    }
    
    public var builder: PropertyBuilder {
        .fromSnapshot(self)
    }
    
}
