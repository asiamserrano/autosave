//
//  Configuration.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation
import SwiftUI

public class Configuration: ObservableObject {
    
    public static var defaultValue: Configuration { .init() }

    @Published public private(set) var alertEnum: AlertEnum = .none
    @Published public private(set) var gameSortEnum: GameSortEnum = .title(.forward)
    @Published public private(set) var menuEnum: MenuEnum = .game(.library)
    
}

public extension Configuration {
    
    var menuBinding: Binding<MenuEnum> {
        .init(get: {
            self.menuEnum
        }, set: { newValue in
            self.menuEnum = newValue
        })
    }
    
}
