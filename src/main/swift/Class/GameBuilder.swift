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
    
    public static var random: GameBuilder {
       .init(.random, .random, .inactive)
    }
    
    @Published public var title: String
    @Published public var release: Date
    @Published public var boxart: Data?
    @Published public var tags: Tags
    
    // view modification
    @Published public var editMode: EditMode
    @Published public var tagType: TagType = .defaultValue
    
    // tracking
    @Published private var added: TagBuilders = .defaultValue
    @Published private var deleted: TagBuilders = .defaultValue
    @Published private var tracker: Tracker
  
    // constant
    public let status: GameStatusEnum
    public let uuid: UUID
    
    public init(_ snap: GameSnapshot, _ tags: Tags, _ edit: EditMode) {
        self.uuid = snap.uuid
        self.title = snap.title
        self.release = snap.release
        self.boxart = snap.boxart
        self.status = snap.status
        self.tags = tags
        self.editMode = edit
        self.tracker = .init(snap, tags)
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

    public func fail() -> Void {
        self.tracker.invalid += self.game
    }

    public func cancel() -> Void {
        let snapshot: GameSnapshot = self.tracker.snapshot
        self.title = snapshot.title
        self.release = snapshot.release
        self.boxart = snapshot.boxart
        self.tags = self.tracker.tags
    }
    
    public func save() -> Void {
        self.added = .defaultValue
        self.deleted = .defaultValue
        self.tracker = .init(self)
    }
    
    public var isDisabled: Bool {
        let o: GameSnapshot = self.game
        let isInvalid: Bool = self.tracker.invalid.contains(o) || o.title_canon.isEmpty
        let isSame: Bool = self.tracker.snapshot == o || self.tracker.tags == self.tags
        return self.editMode == .active ? isInvalid || isSame : false
    }

}

public extension GameBuilder {
    
    var inputs: Inputs { self.tags.inputs }
    var builders: TagBuilders { self.tags.builders }
    
    func add(_ i: InputBuilder) -> Void {
        let builder: TagBuilder = .input(i)
        self.insert(builder)
        self.tags += builder
    }
    
    func delete(_ i: InputBuilder) -> Void {
        let builder: TagBuilder = .input(i)
        print("deleting")
        self.remove(builder)
        self.tags -= builder
    }
    
    func add(_ builder: TagBuilder) -> Void {
        self.insert(builder)
        self.tags += builder
    }
    
    func delete(_ builder: TagBuilder) -> Void {
        print("deleting")
        self.remove(builder)
        self.tags -= builder
    }
    
    func delete(_ input: InputEnum) -> Void {
        self.remove(tags[input])
        self.tags -= input
    }
    
    func delete(_ system: SystemBuilder) -> Void {
        self.remove(tags[system])
        self.tags -= system
    }
    
    func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
        let element: Tags.PlatformsIndex = (system, format)
        self.remove(tags[element])
        self.tags -= element
    }
    
    func delete(_ system: SystemBuilder, _ format: FormatBuilder) -> Void {
        let builder: TagBuilder = .platform(system, format)
        self.delete(builder)
    }
    
    func set(_ member: Platforms.Member) -> Void {
        let system: SystemBuilder = member.key
        self.delete(system)
        self.tags --> (system, member.value)
        self.insert(tags[system])
    }
    
    var count: Int { self.tags.quantity }
    var game: GameSnapshot { .fromBuilder(self) }
    
}

private extension GameBuilder {
    
    func insert(_ builder: TagBuilder) -> Void {
        self.added += builder
        self.deleted -= builder
    }
    
    func insert(_ builders: TagBuilders) -> Void {
        self.added += builders
        self.deleted -= builders
    }
    
    func remove(_ builder: TagBuilder) -> Void {
        let builders: TagBuilders = .init(builder)
        self.remove(builders)
    }
    
    func remove(_ builders: TagBuilders) -> Void {
        self.added -= builders
        self.deleted += builders
    }
    
    struct Tracker {
        
        let snapshot: GameSnapshot
        let tags: Tags
        
        var invalid: SortedSet<GameSnapshot>
        
        init(_ snap: GameSnapshot, _ tags: Tags) {
            self.snapshot = snap
            self.invalid = .init(snap)
            self.tags = tags
        }
        
        init(_ builder: GameBuilder) {
            self.init(builder.game, builder.tags)
        }
        
    }
    
}
