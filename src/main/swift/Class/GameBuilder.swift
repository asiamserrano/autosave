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
    
    @Published private var invalid: Set<GameSnapshot>
        
    
    
    //    @Published public var photosPickerItem: PhotosPickerItem? = nil
    //    @Published public var imagePicker: ImagePickerEnum = .picker
        
    public let status: GameStatusEnum
//    private let original: GameSnapshot
    
    public init(_ status: GameStatusEnum) {
        let snap: GameSnapshot = .defaultValue(status)
        self.title = .defaultValue
        self.release = .defaultValue
        self.boxart = nil
        self.status = status
//        self.original = snap
        self.invalid = .init(snap)
    }
    
    public convenience init(_ model: GameModel) {
        let snap: GameSnapshot = model.snapshot
        self.init(snap)
    }
    
    public init(_ snap: GameSnapshot) {
        self.title = snap.title
        self.release = snap.release
        self.boxart = snap.boxart
        self.status = snap.status
//        self.original = snap
        self.invalid = .init(snap)
    }
    
}

extension GameBuilder {
    
    public var snapshot: GameSnapshot {
        .fromBuilder(self)
    }

    public func fail() -> Void {
        self.invalid.insert(self.snapshot)
    }
    
    public func cancel(_ original: GameSnapshot) -> Void {
        self.title = original.title
        self.release = original.release
        self.boxart = original.boxart
    }
        
    public var isDisabled: Bool {
        let isInvalid: Bool = self.invalid.contains(self.snapshot)
        let isEmpty: Bool = self.snapshot.title_canon.isEmpty
        return isInvalid || isEmpty
    }
    
//    public var uuid: UUID {
//        self.original.uuid
//    }

}
