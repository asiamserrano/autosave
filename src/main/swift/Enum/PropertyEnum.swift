//
//  PropertyCategory.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

//public enum PropertyCategory: Enumerable {
//    case input, mode, platform
//}


public enum SelectedType: Enumerable {
    
    public static func selected(_ builder: SelectedBuilder) -> Self {
        switch builder {
        case .mode:
            return .mode
        case .format:
            return .format
        case .system:
            return .system
        }
    }
    
    case mode, format, system
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
    
    public static var allCases: Cases {
        SelectedType.allCases.flatMap { category in
            switch category {
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
  
}

public enum PropertyCategory: Enumerable {
    case input, selected
}

public enum PropertyType: Encapsulable {
    
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

public enum PropertyBuilder {
    
    /*
     | Field      | Role                                                                                                      |
     | ---------- | --------------------------------------------------------------------------------------------------------- |
     | `category` | Describes how the value is sourced: `selected` (predefined) or `input` (user entry). Formerly your "type" |
     | `type`     | Broad classification of property (e.g., `format`, `system`, `genre`)                                      |
     | `label`    | A specific **group under the type**, may equal the type when no sub-grouping exists                       |
     | `value`    | The concrete, final value associated with the property                                                    |

     */
    
    public static func random(_ label: PropertyLabel) -> Self {
        switch label {
        case .input(let input):
            return .input(input, .random)
        case .selected(let selected):
            let builder: SelectedBuilder = .random(selected)
            return .selected(builder)
        }
    }
    
    case input(InputEnum, String)
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
        case .input(let i, _):
            return .input(i)
        case .selected(let s):
            return .selected(s)
        }
    }
    
    public var label: PropertyLabel {
        switch self {
        case .input(let i, _):
            return .input(i)
        case .selected(let s):
            return .selected(s)
        }
    }
    
    public var stringBuilder: StringBuilder {
        switch self {
        case .input(_, let s):
            return .string(s)
        case .selected(let s):
            return .enumeror(s)
        }
    }
    
    public var entry: String {
        self.stringBuilder.trim
    }
    
}





//public enum PropertyValueEnum: Enumerable {
//    case string(String)
//    case mode(ModeEnum)
//    case
//}


//public enum B {
//    case series
//    case developer
//    case publisher
//    case genre
//    case mode
//    case format
//    case system
//}
//
//public enum subB {
//    case series
//    case developer
//    case publisher
//    case genre
//    case mode
//    case format
//    case system
//}

public enum C {
    case series
    case developer
    case publisher
    case genre
    case mode
    case digital
    case physical
    case playstation
    case nintendo
    case xbox
    case os
}




//case playstation, nintendo, xbox, os//, mq3
//
