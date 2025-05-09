//
//  StringBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct StringBuilder: Hashable {
    
    public static func fromPropertyModel(_ model: PropertyModel) -> Self {
        let key: String = model.value_canon
        let value: String = model.value_trim
        return .init(key, value)
    }
    
    public static func fromPropertyBuilder(_ builder: PropertyBuilder) -> Self {
        switch builder {
        case .input(let inputBuilder):
            let key: String = inputBuilder.string.canonicalized
            let value: String = inputBuilder.string.trimmed
            return .init(key, value)
        case .mode(let modeEnum):
            let key: String = modeEnum.id
            let value: String = modeEnum.rawValue
            return .init(key, value)
        case .platform(let platformBuilder):
            let key: String = platformBuilder.system.id
            let value: String = platformBuilder.format.id
            return .init(key, value)
        }
    }
    
    public let canon: String
    public let trim: String
    
    private init(_ c: String, _ t: String) {
        self.canon = c
        self.trim = t
    }
    
//    private init(_ string: String) {
//        self.canon = string.canonicalized
//        self.trim = string.trimmed
//    }
    

    
//    public init(_ model: PropertyModel) {
//        self.id = model.value_canon
//        self.display = model.value_trim
//    }
    
}
