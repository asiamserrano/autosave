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
    @Published private var master: SortedSet<TagBuilder> = .init()
  
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

private extension GameBuilder {
    
//    struct Snapshot: Stable {
//        var snapshot: GameSnapshot
//        var tags: Tags
//        var invalid: Set<GameSnapshot>
//        
//        init(_ snapshot: GameSnapshot, _ tags: Tags) {
//            self.snapshot = snapshot
//            self.tags = tags
//            self.invalid = .init()
//        }
//        
//        var title: String { snapshot.title }
//        var release: Date { snapshot.release }
//        var boxart: Data? { snapshot.boxart }
//        
//        func isInvalid(_ builder: GameBuilder) -> Bool {
//            let other: GameSnapshot = builder.game
//            return self.invalid.contains(other) || other.title_canon.isEmpty
//        }
//        
//        func equals(_ builder: GameBuilder) -> Bool {
//            self.snapshot == builder.game &&
//            self.tags == builder.tags
//        }
//        
//    }
    
}

extension GameBuilder {
    
    public func add(_ builder: TagBuilder) -> Void {
        self.tags += builder
    }
    
    public func delete(_ builder: TagBuilder) -> Void {
        self.tags -= builder
    }
    
    public func delete(_ system: SystemBuilder) -> Void {
        self.tags -= system
    }
    
    public func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
        self.tags -= (system, format)
    }
    
    public func delete(_ platform: PlatformBuilder) -> Void {
        self.tags -= platform
    }
    
}
