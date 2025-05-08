//
//  GameBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation

public class GameBuilder: ObservableObject {
    
    @Published public var title: String
    @Published public var release: Date
    @Published public var boxart: Data?
    
//    @Published public var photosPickerItem: PhotosPickerItem? = nil
//    @Published public var imagePicker: ImagePickerEnum = .picker
        
    public private(set) var original: GameSnapshot
    
    @Published private var invalid: Set<GameSnapshot>
        
    public let status: GameStatusEnum
    
    public init(_ status: GameStatusEnum) {
        let snap: GameSnapshot = .defaultValue(status)
        self.title = .defaultValue
        self.release = .defaultValue
        self.boxart = nil
        self.status = status
        self.original = snap
        self.invalid = .init(snap)
    }
    
    public convenience init(_ model: GameModel) {
        let snap: GameSnapshot = model.snapshot
        self.init(snap)
    }
    
    public init(_ snap: GameSnapshot) {
        self.original = snap
        self.title = snap.title
        self.release = snap.release
        self.boxart = snap.boxart
        self.status = snap.status
        self.original = snap
        self.invalid = .init(snap)
    }
    
}

extension GameBuilder {
    
    public var snapshot: GameSnapshot {
        .fromBuilder(self)
    }
    
//    public func save() -> Void {
//        let snap: GameSnapshot = self.snapshot
//        self.original = snap
//        self.invalid = .init(snap)
//    }
    
    public func fail() -> Void {
        self.invalid.insert(self.snapshot)
    }
    
    public func reset() -> Void {
        self.title = original.title
        self.release = original.release
        self.boxart = original.boxart
    }
    
    func cancel() -> Void {
        self.title = original.title
        self.release = original.release
        self.boxart = original.boxart
    }
        
    public var isDisabled: Bool {
        self.invalid.contains(self.snapshot) || self.snapshot.title_canon.isEmpty
    }
    
//    public var isNew: Bool {
//        self.original == .defaultValue(self.status)
//    }
    
//    public var uuid: UUID {
//        self.original.uuid
//    }
    
}
