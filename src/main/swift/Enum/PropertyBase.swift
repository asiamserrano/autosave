////
////  PropertyBase.swift
////  autosave
////
////  Created by Asia Serrano on 5/19/25.
////
//
//import Foundation
//
//public enum PropertyBase: Encapsulable {
//    
//    public static var allCases: Cases {
//        PropertyCategory.allCases.flatMap { category in
//            switch category {
//            case .mode:
//                return Cases.init(.mode)
//            case .input:
//                return InputEnum.cases.map(Self.input)
//            case .platform:
//                return PlatformBase.cases.map(Self.platform)
//            }
//        }
//    }
//
//    case mode
//    case input(InputEnum)
//    case platform(PlatformBase)
//    
//    public var enumeror: Enumeror {
//        switch self {
//        case .mode:
//            return PropertyCategory.mode
//        case .input(let i):
//            return i
//        case .platform(let p):
//            return p
//        }
//    }
//    
//}
