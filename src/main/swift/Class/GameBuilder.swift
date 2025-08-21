//
//  GameBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation
import SwiftUI
import PhotosUI

// TODO: implement logic that keeps track of what properties were added and deleted
public class GameBuilder: ObservableObject {
    
    @Published public var title: String
    @Published public var release: Date
    @Published public var boxart: Data?
    @Published public var tags: Tags
    
    // view modification
    @Published public var editMode: EditMode
    @Published public var tagType: TagType = .defaultValue
    
    // tag tracking
//    @Published private var master: SortedSet<TagBuilder> = .init()
    
    @Published private var added: TagBuilders = .defaultValue
    @Published private var deleted: TagBuilders = .defaultValue

  
    // constant
    public let status: GameStatusEnum
    public let uuid: UUID
    
    private init(_ snap: GameSnapshot, _ tags: Tags, _ edit: EditMode) {
        self.uuid = snap.uuid
        self.title = snap.title
        self.release = snap.release
        self.boxart = snap.boxart
        self.status = snap.status
        self.tags = tags
        self.editMode = edit
    }
    
    public convenience init(_ status: GameStatusEnum) {
        let snap: GameSnapshot = .defaultValue(status)
        self.init(snap, .defaultValue, .active)
    }
    
    public convenience init(_ model: GameModel, _ relations: [RelationModel], _ properties: [PropertyModel]) {
        let snap: GameSnapshot = model.snapshot
        let tags: Tags = .build(relations, properties)
        self.init(snap, tags, .inactive)
    }
    
}

extension GameBuilder {

//    public func fail() -> Void {
//        self.original.invalid.insert(self.game)
//    }
//    
//    public func cancel() -> Void {
//        self.title = self.original.title
//        self.release = self.original.release
//        self.boxart = self.original.boxart
//        self.tags = self.original.tags
//    }
//    
//    public func save() -> Void {
//        self.original.snapshot = self.game
//        self.original.tags = self.tags
//        self.original.invalid = .init()
//    }
//        
//    public var isDisabled: Bool {
//        let isInvalid: Bool = self.original.isInvalid(self)
//        let isSame: Bool = self.original.equals(self)
//        return self.editMode == .active ? isInvalid || isSame : false
//    }
    
    public var count: Int {
        self.tags.quantity
    }
    
    public var game: GameSnapshot {
        .fromBuilder(self)
    }

}

public extension GameBuilder {
    
    static var random: GameBuilder {
       .init(.random, .random, .inactive)
    }
    
    func add(_ builder: TagBuilder) -> Void {
        self.insert(builder)
        self.tags += builder
    }
    
    func delete(_ builder: TagBuilder) -> Void {
        self.remove(builder)
        self.tags -= builder
    }
    
    func delete(_ input: InputEnum) -> Void {
        let builders: TagBuilders = self.tags[input].builders
        self.remove(builders)
        self.tags -= input
    }
    
    func delete(_ system: SystemBuilder) -> Void {
        let builders: TagBuilders = self.tags[system].builders
        self.remove(builders)
        self.tags -= system
    }
    
    func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
        let element: Tags.PlatformsIndex = (system, format)
        let builders: TagBuilders = self.tags[element].builders
        self.remove(builders)
        self.tags -= element
    }
    
    func delete(_ platform: PlatformBuilder) -> Void {
        let builder: TagBuilder = .platform(platform)
        self.delete(builder)
    }
    
}

private extension GameBuilder {
    
    func insert(_ builder: TagBuilder) -> Void {
        self.added += builder
        self.deleted -= builder
    }
    
    func remove(_ builder: TagBuilder) -> Void {
        let builders: TagBuilders = .init(builder)
        self.remove(builders)
    }
    
    func remove(_ builders: TagBuilders) -> Void {
        self.added -= builders
        self.deleted += builders
    }
    
}
