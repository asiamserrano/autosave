//
//  AttributeEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import Foundation

// TODO: make this PropertyEnum
public enum AttributeEnum: Encapsulable {
    
    public static var allCases: Cases {
        TypeEnum.allCases.flatMap { category in
            switch category {
            case .mode:
                return Cases.init(.mode)
            case .input:
                return InputEnum.cases.map(Self.input)
            case .platform:
                return PlatformEnum.cases.map(Self.platform)
            }
        }
    }

    case mode
    case input(InputEnum)
    case platform(PlatformEnum)
    
    public var enumeror: Enumeror {
        switch self {
        case .mode: return TypeEnum.mode
        case .input(let i): return i
        case .platform(let p): return p
        }
    }
    
}

extension AttributeEnum {
    
    public enum TypeEnum: Enumerable {
        case mode, input, platform
    }
    
}

