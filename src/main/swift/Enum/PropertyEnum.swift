//
//  PropertyCategory.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum SelectedType: Enumerable {
    
    public static func selected(_ builder: SelectedBuilder) -> Self {
        switch builder {
        case .mode:
            return .mode
        case .system:
            return .system
        case .format:
            return .format
        }
    }
    
    case mode, system, format
}

public enum SelectedBuilder: Encapsulable {
    
    public static var allCases: Cases {
        SelectedType.allCases.flatMap { category in
            switch category {
            case .mode:
                return ModeEnum.cases.map(Self.mode)
            case .format:
                return FormatBuilder.cases.map(Self.format)
            case .system:
                return SystemBuilder.cases.map(Self.system)
            }
        }
    }
    
    public static func random(_ label: SelectedLabel) -> Self {
        switch label {
        case .mode:
            return .mode(.random)
        case .format(let format):
            let builder: FormatBuilder = .random(format)
            return .format(builder)
        case .system(let system):
            let builder: SystemBuilder = .random(system)
            return .system(builder)
        }
    }
    
    case mode(ModeEnum)
    case format(FormatBuilder)
    case system(SystemBuilder)
  
    public var enumeror: Enumeror {
        switch self {
        case .mode(let m):
            return m
        case .format(let f):
            return f
        case .system(let s):
            return s
        }
    }
    
}

public enum SelectedLabel: Encapsulable {
    
    public static func filter(_ type: SelectedType) -> Cases {
        Self.cases.filter { $0.type == type }
    }
    
    public static var allCases: Cases {
        SelectedType.allCases.flatMap { type in
            switch type {
            case .mode:
                return Cases.init(.mode)
            case .format:
                return FormatEnum.cases.map(Self.format)
            case .system:
                return SystemEnum.cases.map(Self.system)
            }
        }
    }
    
    public static func selected(_ builder: SelectedBuilder) -> Self {
        switch builder {
        case .mode:
            return .mode
        case .format(let format):
            let formatEnum: FormatEnum = format.type
            return .format(formatEnum)
        case .system(let system):
            let systemEnum: SystemEnum = system.type
            return .system(systemEnum)
        }
    }
    
    case mode
    case format(FormatEnum)
    case system(SystemEnum)
    
    public var enumeror: Enumeror {
        switch self {
        case .mode:
            return SelectedType.mode
        case .format(let f):
            return f
        case .system(let s):
            return s
        }
    }
    
    public var type: SelectedType {
        switch self {
        case .mode:
            return .mode
        case .format:
            return .format
        case .system:
            return .system
        }
    }
  
}





public enum PropertyCategory: Enumerable {
    case input, selected
}

public enum PropertyType: Encapsulable {
    
    public static func filter(_ category: PropertyCategory) -> Cases {
        Self.cases.filter { $0.category == category }
    }
    
    public static var allCases: Cases {
        PropertyCategory.allCases.flatMap { category in
            switch category {
            case .input:
                return InputEnum.cases.map(Self.input)
            case .selected:
                return SelectedType.cases.map(Self.selected)
            }
        }
    }
    
    public static func selected(_ builder: SelectedBuilder) -> Self {
        let type: SelectedType = .selected(builder)
        return .selected(type)
    }
    
    case input(InputEnum)
    case selected(SelectedType)
    
    public var enumeror: Enumeror {
        switch self {
        case .input(let i):
            return i
        case .selected(let s):
            return s
        }
    }
    
    public var category: PropertyCategory {
        switch self {
        case .input:
            return .input
        case .selected:
            return .selected
        }
    }
    
}

public enum PropertyLabel: Encapsulable {
    
    public static var allCases: Cases {
        PropertyCategory.allCases.flatMap { category in
            switch category {
            case .input:
                return InputEnum.cases.map(Self.input)
            case .selected:
                return SelectedLabel.cases.map(Self.selected)
            }
        }
    }
    
    public static func selected(_ builder: SelectedBuilder) -> Self {
        let label: SelectedLabel = .selected(builder)
        return .selected(label)
    }
    
    case input(InputEnum)
    case selected(SelectedLabel)
    
    public var enumeror: Enumeror {
        switch self {
        case .input(let i):
            return i
        case .selected(let s):
            return s
        }
    }
    
}

public enum PropertyBuilder: Stable, Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.label == rhs.label {
            return lhs.value < rhs.value
        } else {
            return lhs.label < rhs.label
        }
    }
    
    /*
     | Field      | Role                                                                                                      |
     | ---------- | --------------------------------------------------------------------------------------------------------- |
     | `category` | Describes how the value is sourced: `selected` (predefined) or `input` (user entry). Formerly your "type" |
     | `type`     | Broad classification of property (e.g., `format`, `system`, `genre`)                                      |
     | `label`    | A specific **group under the type**, may equal the type when no sub-grouping exists                       |
     | `value`    | The concrete, final value associated with the property                                                    |

     */
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let category: PropertyCategory = .init(model.category_id)
        switch category {
        case .input:
            let input: InputEnum = .init(model.type_id)
            let value: String = model.value_trim
            let builder: InputBuilder = .init(input, value)
            return .input(builder)
        case .selected:
            let builder: SelectedBuilder = .init(model.value_canon)
            return .selected(builder)
        }
    }
        
    public static func random(_ label: PropertyLabel) -> Self {
        switch label {
        case .input(let input):
            let builder: InputBuilder = .random(input)
            return .input(builder)
        case .selected(let selected):
            let builder: SelectedBuilder = .random(selected)
            return .selected(builder)
        }
    }
    
    case input(InputBuilder)
    case selected(SelectedBuilder)
    
    public var category: PropertyCategory {
        switch self {
        case .input:
            return .input
        case .selected:
            return .selected
        }
    }
    
    public var type: PropertyType {
        switch self {
        case .input(let i):
            return .input(i.type)
        case .selected(let s):
            return .selected(s)
        }
    }
    
    public var label: PropertyLabel {
        switch self {
        case .input(let i):
            return .input(i.type)
        case .selected(let s):
            return .selected(s)
        }
    }
    
    public var tag: TagType {
        switch self {
        case .input(let i):
            return .input(i.type)
        case .selected(let s):
            switch s {
            case .mode:
                return .mode
            default:
                return .platform
            }
        }
    }
    
    public var value: StringBuilder {
        switch self {
        case .input(let i):
            return .string(i.string)
        case .selected(let s):
            return .enumeror(s)
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.label)
        hasher.combine(self.value)
    }
    
}

public struct PropertySnapshot: Uuidentifiable {
    
    public static var random: Self {
        .init(.random(.random))
    }
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let uuid: UUID = model.uuid
        let builder: PropertyBuilder = .fromModel(model)
        return .init(builder, uuid)
    }
    
    public static func fromBuilder(_ builder: PropertyBuilder) -> Self {
        .init(builder)
    }
    
    public let uuid: UUID
    public let builder: PropertyBuilder
    
    private init(_ builder: PropertyBuilder, _ uuid: UUID = .init()) {
        self.uuid = uuid
        self.builder = builder
    }
    
    public var type_id: String {
        self.builder.type.id
    }
    
    public var category_id: String {
        self.builder.category.id
    }
    
    public var label_id: String {
        self.builder.label.id
    }
    
    public var value_canon: String {
        self.builder.value.canon
    }
    
    public var value_trim: String {
        self.builder.value.trim
    }

}

public struct PlatformBuilder: Identifiable, Hashable, Enumerable {
    
    public static func fromModels(_ key: PropertyModel, _ value: PropertyModel) -> Self? {
        let s: PropertyBuilder = .fromModel(key)
        let f: PropertyBuilder = .fromModel(value)
        switch (s, f) {
        case (.selected(let sys), .selected(let form)):
            switch (sys, form) {
            case (.system(let system), .format(let format)):
                return .init(system, format)
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    public static var allCases: [Self] {
        SystemBuilder.cases.flatMap { system in
            system.formatBuilders.map { format in
                return .init(system, format)
            }
        }
    }
    
    public static var random: Self {
        let system: SystemBuilder = .random
        let format: FormatBuilder = .random(system)
        return .init(system, format)
    }
    
    public let system: SystemBuilder
    public let format: FormatBuilder
    
    public init(_ system: SystemBuilder, _ format: FormatBuilder) {
        self.system = system
        self.format = format
    }
    
//    public var id: Int {
//        self.hashValue
//    }
    
    
}
