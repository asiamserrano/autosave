//
//  GameBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation
import SwiftUI
import PhotosUI

public class GameBuilder: ObservableObject {
    
    @Published public var title: String
    @Published public var release: Date
    @Published public var boxart: Data?
    
//    // TODO: implement logic that keeps track of what properties were added and deleted
//    @Published public var tags: Tags
    
    @Published public var tags: TagContainer
    
    @Published public var editMode: EditMode
    
    @Published private var original: Snapshot
    
    @Published public var tagType: TagType = .defaultValue
    
    @Published private var master: SortedSet<TagBuilder> = .init()
  
    public let status: GameStatusEnum
    public let uuid: UUID
    
    private init(_ snap: GameSnapshot, _ tags: TagContainer, _ edit: EditMode) {
        self.uuid = snap.uuid
        self.title = snap.title
        self.release = snap.release
        self.boxart = snap.boxart
        self.status = snap.status
        self.tags = tags
        self.editMode = edit
        
        self.original = .init(snap, tags)
    }
    
    public convenience init(_ status: GameStatusEnum) {
        let snap: GameSnapshot = .defaultValue(status)
        self.init(snap, .defaultValue, .active)
    }
    
    public convenience init(_ model: GameModel, _ relations: [RelationModel], _ properties: [PropertyModel]) {
        let snap: GameSnapshot = model.snapshot
//        let container: TagContainer = .build(relations, properties)
        self.init(snap, .defaultValue, .inactive)
    }
    
}

extension GameBuilder {

    public func fail() -> Void {
        self.original.invalid.insert(self.game)
    }
    
    public func cancel() -> Void {
        self.title = self.original.title
        self.release = self.original.release
        self.boxart = self.original.boxart
        self.tags = self.original.tags
    }
    
    public func save() -> Void {
        self.original.snapshot = self.game
        self.original.tags = self.tags
        self.original.invalid = .init()
    }
        
    public var isDisabled: Bool {
        let isInvalid: Bool = self.original.isInvalid(self)
        let isSame: Bool = self.original.equals(self)
        return self.editMode == .active ? isInvalid || isSame : false
    }
    
    public var count: Int {
        self.tags.quantity
    }
    
    public var game: GameSnapshot {
        .fromBuilder(self)
    }

}

private extension GameBuilder {
    
    struct Snapshot: Stable {
        var snapshot: GameSnapshot
        var tags: TagContainer
        var invalid: Set<GameSnapshot>
        
        init(_ snapshot: GameSnapshot, _ tags: TagContainer) {
            self.snapshot = snapshot
            self.tags = tags
            self.invalid = .init()
        }
        
        var title: String { snapshot.title }
        var release: Date { snapshot.release }
        var boxart: Data? { snapshot.boxart }
        
        func isInvalid(_ builder: GameBuilder) -> Bool {
            let other: GameSnapshot = builder.game
            return self.invalid.contains(other) || other.title_canon.isEmpty
        }
        
        func equals(_ builder: GameBuilder) -> Bool {
            self.snapshot == builder.game &&
            self.tags == builder.tags
        }
        
    }
    
}

extension GameBuilder {
    
    public typealias Builder = TagBuilder
    
//    public func add(_ builder: Builder) -> Void {
//        self.tags += builder
//    }
//    
//    public func set(_ element: Systems.Element) -> Void {
////        let system: SystemBuilder = element.key
////        self.tags.get(system).allBuilders.map {  PlatformBuilder(system, $0) }.map(TagBuilder.platform).forEach(self.delete)
////        element.value.allBuilders.map {  PlatformBuilder(system, $0) }.map(TagBuilder.platform).forEach(self.add)
//    }
//    
//    public func delete(_ builder: Builder) -> Void {
//        self.tags -= builder
//    }
//    
//    private func delete(_ system: SystemBuilder, _ formats: FormatBuilders) -> Void {
//        formats.map { PlatformBuilder(system, $0) }.map(TagBuilder.platform).forEach(self.delete)
//    }
//    
//    public func delete(_ system: SystemBuilder) -> Void {
//        let formats: Formats = self.tags.get(system)
//        formats.keys.forEach { self.delete(system, $0) }
//    }
//    
////    public func delete(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder) -> Void {
////        let systems: Systems = self.tags.get
//////        let formats: Formats = self.tags.get(system)
//////        formats.values.forEach { self.delete(system, $0) }
////    }
//    
//    public func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
//        let formats: Formats = self.tags.get(system)
//        let builders: FormatBuilders = formats[format] ?? .defaultValue
//        self.delete(system, builders)
//    }
//    
//    public func delete(_ system: SystemBuilder, _ format: FormatBuilder) -> Void {
//        let platform: PlatformBuilder = .init(system, format)
//        let builder: TagBuilder = .platform(platform)
//        self.delete(builder)
//    }
    
}
