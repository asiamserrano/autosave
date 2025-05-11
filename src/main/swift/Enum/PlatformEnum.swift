//
//  PlatformEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import Foundation

public enum PlatformEnum: Enumerable {
    
    case system
    case format
    
    var propertyEnum: PropertyEnum {
        .platform
    }
    
}
