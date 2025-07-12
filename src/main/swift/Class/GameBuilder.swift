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
    @Published public var tags: Tags
    
    @Published public var editMode: EditMode
    
    // TODO: determine logic for if done button is disabled
    @Published private var original: Snapshot
    
    @Published public var tagType: TagType = .defaultValue
  
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
        
        self.original = .init(snap, tags)
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

}

private extension GameBuilder {
    
    var game: GameSnapshot {
        .fromBuilder(self)
    }
    
    
    
    struct Snapshot: Stable {
        var snapshot: GameSnapshot
        var tags: Tags
        var invalid: Set<GameSnapshot>
        
        init(_ snapshot: GameSnapshot, _ tags: Tags) {
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
