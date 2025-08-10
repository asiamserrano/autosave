////
////  TestingObject.swift
////  autosave
////
////  Created by Asia Serrano on 8/4/25.
////
//
//import Foundation
//
//public struct TagContainer {
//    
//    public var builders: Builders = .defaultValue
//    
//    private var inputs: Inputs = .defaultValue
//    private var modes: Modes = .defaultValue
//    private var platforms: Platforms = .defaultValue
//    
//}
//
//private extension TagContainer {
//    
//    static var RANDOM_RANGE: Range<Int> = 0..<3
//    
//}
//
//public extension TagContainer {
//    
//    typealias Builder = TagBuilder
//    typealias Builders = SortedSet<Builder>
//    
//    enum Element: Quantifiable {
//        case inputs(Inputs)
//        case modes(Modes)
//        case platforms(Platforms)
//
//        public var quantity: Int {
//            switch self {
//            case .inputs(let inputs):
//                return inputs.count
//            case .modes(let modes):
//                return modes.count
//            case .platforms(let platforms):
//                return platforms.count
//            }
//        }
//
//    }
//    
//    static func ==(lhs: Self, rhs: Builders) -> Bool {
//        lhs.builders == rhs
//    }
//    
//    static func +=(lhs: inout Self, rhs: Builder?) -> Void {
//        if let builder: Builder = rhs {
//            switch builder {
//            case .input(let input):
//                lhs.inputs += input
//            case .mode(let mode):
//                lhs.modes += mode
//            case .platform(let platform):
//                lhs.platforms += platform
//            }
//            
//            lhs.builders += builder
//        }
//    }
//    
//    static func -=(lhs: inout Self, rhs: Builder?) -> Void {
//        if let builder: Builder = rhs {
//            switch builder {
//            case .input(let input):
//                lhs.inputs -= input
//            case .mode(let mode):
//                lhs.modes -= mode
//            case .platform(let platform):
//                print(platform)
//                lhs.platforms -= platform
//            }
//            
//            lhs.builders -= builder
//        }
//    }
//    
//    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
//        var new: Self = .init()
//        relations.forEach {
//            if let builder: Builder = $0.getTagBuilder(properties) {
//                new += builder
//            }
//        }
//        return new
//    }
//    
//    static func random(_ status: GameStatusEnum) -> Self {
//        switch status {
//        case .library:
//            return .random
//        case .wishlist:
//            return .defaultValue
//        }
//    }
//
//    static var random: Self {
//        var new: Self = .init()
//        
//        var bool: Bool = false
//        
//        InputEnum.cases.forEach { i in
//            let strings: StringBuilders = .random(RANDOM_RANGE)
//            strings.forEach { value in
//                let input: InputBuilder = .init(i, value.trim)
//                new += (.input(input))
//            }
//        }
//        
//        ModeEnum.allCases.forEach { mode in
//            bool = .random()
//            if bool {
//                new += (.mode(mode))
//            }
//        }
//        
//        let systems: SortedSet<SystemBuilder> = .random(RANDOM_RANGE)
//        
//        systems.forEach { system in
//            system.formatBuilders.forEach { format in
//                bool = .random()
//                if bool {
//                    let platform: PlatformBuilder = .init(system, format)
//                    new += (.platform(platform))
//                }
//            }
//        }
//        
//        return new
//    }
//    
//    func get(_ category: TagCategory) -> Element {
//        switch category {
//        case .input:
//            return .inputs(self.inputs)
//        case .mode:
//            return .modes(self.modes)
//        case .platform:
//            return .platforms(self.platforms)
//        }
//    }
//    
//    func get(_ tagType: TagType) -> Element {
//        self.get(tagType.category)
//    }
//    
//    func get(_ system: Systems.K?) -> Formats {
//        if let system: Systems.K = system {
//            return self.platforms.get(system)
//        } else {
//            return .defaultValue
//        }
//    }
//    
//    func contains(_ builder: Builder) -> Bool {
//        self.builders.contains(builder)
//    }
//    
//    var systems: [Systems.K] {
//        self.platforms.flatMap { $0.value.keys }
//    }
//    
//}
//
//extension TagContainer: Stable {
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self.builders)
//    }
//    
//}
//
//extension TagContainer: Defaultable {
//    
//    public static var defaultValue: Self { .init() }
//    
//}
//
//extension TagContainer: Quantifiable {
//    
//    public var quantity: Int { self.builders.count }
//    
//}
