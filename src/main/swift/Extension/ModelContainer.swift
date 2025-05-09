//
//  ModelContainer.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContainer {
    
    private convenience init(memory: Bool) {
        do {
            let schema: Schema = .init(.defaultValue)
            let config: ModelConfiguration = .init(schema: schema, isStoredInMemoryOnly: memory)
            try self.init(for: schema, configurations: .init(config))
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    public static let preview: ModelContainer = .init(memory: true)
 
}
