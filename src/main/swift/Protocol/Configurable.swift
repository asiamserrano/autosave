//
//  Configurable.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import Foundation
import SwiftUI

public protocol Configurable: View {
    var configuration: Configuration { get }
}

extension Configurable {
    
    public var menu: MenuEnum {
        self.configuration.menuEnum
    }
    
    public func setNavigation(_ builder: GameBuilder, _ input: InputEnum, _ strings: [String]) {
        let navigation: NavigationEnum = .property(builder, input, strings)
        self.configuration.setNavigation(navigation)
    }
    
}
