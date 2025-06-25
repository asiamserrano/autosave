////
////  TagsBuilder.swift
////  autosave
////
////  Created by Asia Serrano on 6/23/25.
////
//
//import Foundation
//
//
//// TODO: finish this implementation
//public class TagsBuilder: ObservableObject {
//    
//    
//    // TODO: ****NOTE***** @Published only works on primative types (ie: observable object variable in another observable object will only update view if the entire variable is assigned --> self.observableObject = self.observableObject.update())
//    
//    @Published public private(set) var inputs: [InputEnum: [String]]
//    @Published public private(set) var modes: [ModeEnum: Bool]
//    @Published public private(set) var platforms: [SystemBuilder: [FormatBuilder]]
//        
//    private init() {
//        self.inputs = .init()
//        self.modes = .init()
//        self.platforms = .init()
//    }
//    
//    private convenience init(_ builders: [TagBuilder]) {
//        self.init()
//        builders.forEach(self.insert)
//    }
//    
//    public convenience init(_ snapshot: TagsSnapshot) {
//        self.init(snapshot.sorted)
//    }
//    
//    public var snapshot: TagsSnapshot {
//        .fromBuilder(self)
//    }
//    
//    public func insert(_ builder: TagBuilder) -> Void {
//        switch builder {
//        case .input(let i):
//            let key: InputEnum = i.type
//            let element: String = i.string
//            var value: [String] = self.inputs.getOrDefault(key)
//            value.append(element)
//            self.inputs[key] = value
//        case .mode(let m):
//            self.modes[m] = true
//        case .platform(let p):
//            let key: SystemBuilder = p.system
//            let element: FormatBuilder = p.format
//            var value: [FormatBuilder] = self.platforms.getOrDefault(key)
//            value.append(element)
//            self.platforms[key] = value
//        }
//    }
//    
//    public func remove(_ builder: TagBuilder) -> Void {
//        switch builder {
//        case .input(let i):
//            let key: InputEnum = i.type
//            let element: String = i.string
//            let value: [String] = self.inputs.getOrDefault(key)
//            self.inputs[key] = value.remove(element)
//        case .mode(let m):
//            self.modes[m] = false
//        case .platform(let p):
//            let key: SystemBuilder = p.system
//            let element: FormatBuilder = p.format
//            let value: [FormatBuilder] = self.platforms.getOrDefault(key)
//            self.platforms[key] = value.remove(element)
//        }
//    }
//        
//}
//
//public struct TagsSnapshot: Identifiable, Hashable {
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.hashValue == rhs.hashValue
//    }
//    
//    public static func fromBuilder(_ tags: TagsBuilder) -> Self {
//        .init([
//            tags.inputs.flatMap { key, values in
//                values.map { value in
//                    let input: InputBuilder = .init(key, value)
//                    return .input(input)
//                }
//            },
//            tags.modes.compactMap { key, value in
//                return value ? .mode(key) : nil
//            },
//            tags.platforms.flatMap { key, values in
//                values.map { value in
//                    let platform: PlatformBuilder = .init(key, value)
//                    return .platform(platform)
//                }
//            }
//        ].flatMap { $0 })
//    }
//    
//    public static func fromModels(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
//        .init(relations.compactMap { relation in
//            if let key: PropertyModel = properties.get(relation.key_uuid) {
//                let property: PropertyBuilder = .fromModel(key)
//                switch property {
//                case .input(let i):
//                    return .input(i)
//                case .selected(let s):
//                    switch s {
//                    case .mode(let m):
//                        return .mode(m)
//                    default:
//                        if let value: PropertyModel = properties.get(relation.value_uuid),
//                           let platform: PlatformBuilder = .fromModels(key, value) {
//                            return .platform(platform)
//                        }
//                    }
//                }
//            }
//            return nil
//        })
//    }
//    
//    public typealias Element = TagBuilder
//    public typealias ElementSet = Set<Element>
//    public typealias ElementArray = [Element]
//
//    private var elements: ElementSet
//    
//    private init(_ elements: ElementArray) {
//        self.elements = .init(elements)
//    }
//    
//    public var sorted: ElementArray {
//        self.elements.sorted()
//    }
//    
//    public var id: Int {
//        self.hashValue
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        self.sorted.forEach {
//            hasher.combine($0)
//        }
//    }
//    
//}
