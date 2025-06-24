//
//  StringBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct StringBuilder: Hashable, Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.canon == rhs.canon {
            return lhs.trim < rhs.trim
        } else {
            return lhs.canon < rhs.canon
        }
    }
    
    public static func enumeror(_ enumeror: Enumeror) -> Self {
        let canon: String = enumeror.id
        let trim: String = enumeror.rawValue
        return .init(canon, trim)
    }
    
    public static func string(_ string: String) -> Self {
        let canon: String = string.canonicalized
        let trim: String = string.trimmed
        return .init(canon, trim)
    }
    
//    public static func fromPropertyModel(_ model: PropertyModel) -> Self {
//        let key: String = model.value_canon
//        let value: String = model.value_trim
//        return .init(key, value)
//    }
    
//    public static func fromPropertyBuilder(_ builder: PropertyBuilder) -> Self {
//        switch builder {
//        case .input(let inputBuilder):
//            let key: String = inputBuilder.string.canonicalized
//            let value: String = inputBuilder.string.trimmed
//            return .init(key, value)
//        case .mode(let modeEnum):
//            return .init(modeEnum)
//        case .platform(let platformBuilder):
//            return .init(platformBuilder)
//        }
//    }
    
    public let canon: String
    public let trim: String
    
    private init(_ c: String, _ t: String) {
        self.canon = c
        self.trim = t
    }
    
//    public init(_ string: String) {
//        let canon: String = string.canonicalized
//        let trim: String = string.trimmed
//        self.init(canon, trim)
//    }
    
//    public init(_ enumeror: Enumeror) {
//        let canon: String = enumeror.id
//        let trim: String = enumeror.rawValue
//        self.init(canon, trim)
//    }
    
}
