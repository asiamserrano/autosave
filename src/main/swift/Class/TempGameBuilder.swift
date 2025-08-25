//
//  TempGameBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 8/24/25.
//

import Foundation
import SwiftUI
import PhotosUI

// TODO: implement logic that keeps track of what properties were added and deleted
public class TempGameBuilder: ObservableObject {
    
    public static var random: TempGameBuilder {
       .init(.random)
    }
    
    // tracking
    @Published private var added: TagBuilders = .defaultValue
    @Published private var deleted: TagBuilders = .defaultValue

//    @Published public private(set) var inputs: Inputs
//    @Published public private(set) var modes: Modes
    
    @Published public private(set) var tags: Tags
    
    public init(_ tags: Tags) {
        self.added = .defaultValue
        self.deleted = .defaultValue
        self.tags = tags
    }
    
//    public init(_ inputs: Inputs) {
//        self.added = .defaultValue
//        self.deleted = .defaultValue
//        self.inputs = inputs
//        self.modes = .defaultValue
//    }
    
    public var inputs: Inputs { self.tags.inputs }
    
    public var builders: TagBuilders {
        self.tags.builders
    }
    
}

public extension TempGameBuilder {
    
    func add(_ builder: TagBuilder) -> Void {
        self.insert(builder)
        self.tags += builder
    }
    
    func delete(_ builder: TagBuilder) -> Void {
        self.remove(builder)
        self.tags -= builder
    }
    
    func add(_ i: InputBuilder) -> Void {
        self.add(.input(i))
    }
    
    func delete(_ i: InputBuilder) -> Void {
        self.remove(.input(i))
    }
    
//    func delete(_ input: InputEnum) -> Void {
//        self.remove(tags[input])
//        self.tags -= input
//    }
//    
//    func delete(_ system: SystemBuilder) -> Void {
//        self.remove(tags[system])
//        self.tags -= system
//    }
//    
//    func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
//        let element: Tags.PlatformsIndex = (system, format)
//        self.remove(tags[element])
//        self.tags -= element
//    }
//    
//    func delete(_ system: SystemBuilder, _ format: FormatBuilder) -> Void {
//        let builder: TagBuilder = .platform(system, format)
//        self.delete(builder)
//    }
//    
//    func set(_ member: Platforms.Member) -> Void {
//        let system: SystemBuilder = member.key
//        self.delete(system)
//        self.tags --> (system, member.value)
//        self.insert(tags[system])
//    }
    
}

private extension TempGameBuilder {
    
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
    
}
