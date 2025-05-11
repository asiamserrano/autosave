//
//  PlatformBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public struct PlatformBuilder {
    
    let system: SystemBuilder
    let format: FormatBuilder
    
    public init(_ system: SystemBuilder, _ format: FormatBuilder) {
        self.system = system
        self.format = format
    }
    
}
