//
//  Array.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension Array {
    
    public static var defaultValue: Self { .init() }
    
    public init(_ elements: Element...) {
        self = elements
    }
    
    public var randomElement: Element {
        if let element: Element = self.randomElement() {
            return element
        } else {
            fatalError("unable to get random element for empty array: \(self)")
        }
    }
    
}

public extension Array where Element: Hashable {
    
    var deduped: Self {
        let set: Set<Element> = .init(self)
        return set.map(\.self)
    }
    
    func remove(_ element: Element) -> Self {
        self.filter { $0 != element }
    }
    
}

extension Array where Element == any PersistentModel.Type {
    
    public static var defaultValue: Self {
        .init(GameModel.self, PropertyModel.self, RelationModel.self)
    }
    
}

extension Array where Element == GameSortDescriptor {

//    public static func defaultValue(_ sort: GameSortEnum) -> Self {
//        let key: Element = sort.descriptor
//        let value: Element = sort.toggleSort.descriptor
//        return .init(key, value)
//    }
    
    public static var defaultValue: Self {
        let sort: GameSortEnum = .defaultValue
        let key: Element = sort.descriptor
        let value: Element = sort.toggleSort.descriptor
        return .init(key, value)
    }
    
}

extension Array where Element == PropertySortDescriptor {
    
    public static var defaultValue: Self {
        .init(.category, .type, .label, .value)
    }
    
}

extension Array where Element == RelationModel {

    public var property_uuids: [UUID] {
        self.flatMap { [$0.key_uuid, $0.value_uuid] }.deduped
    }
    
    public func filter(_ category: TagCategory) -> Self {
        return self.filter { element in
            let tag: TagType = .init(element.type_id)
            return tag.category == category
        }
    }
    
}

extension Array where Element == FormatBuilder {
    
    public var keys: [FormatEnum] {
        self.map { $0.type }.deduped
    }
    
    public func filter(_ type: FormatEnum) -> Self {
        self.filter { $0.type == type }.deduped
    }
    
    public var joined: String {
        self.map { $0.rawValue }.joined(separator: ", ")
    }
    
}

extension Array where Element == TagBuilder {

    public init(_ category: TagCategory, _ relations: [RelationModel], _ properties: [PropertyModel]) {
        self =  relations.filter(category).compactMap { relation in
            if let key: PropertyModel = properties.get(relation.key_uuid) {
                let property: PropertyBuilder = .fromModel(key)
                switch property {
                case .input(let i):
                    return .input(i)
                case .selected(let s):
                    switch s {
                    case .mode(let m):
                        return .mode(m)
                    default:
                        if let value: PropertyModel = properties.get(relation.value_uuid),
                           let platform: PlatformBuilder = .fromModels(key, value) {
                            return .platform(platform)
                        }
                    }
                }
            }
            return nil
        }
    }
        
}

extension Array where Element == PlatformBuilder {

    public init(_ relations: [RelationModel], _ properties: [PropertyModel]) {
        self = relations.compactMap { relation in
            if let key: PropertyModel = properties.get(relation.key_uuid),
               let value: PropertyModel = properties.get(relation.value_uuid) {
                return .fromModels(key, value)
            }
            return nil
        }
    }
    
    public var systems: [SystemBuilder] {
        self.map { $0.system }.deduped.sorted()
    }
    
    public func filter(_ system: SystemBuilder) -> Tags.Platforms.Value {
        .init(self.filter { $0.system == system }.map { $0.format })
    }
    
}

extension Array where Element == PropertyModel {
    
    public func get(_ uuid: UUID) -> Element? {
        self.first(where: { $0.uuid == uuid })
    }
    
}
