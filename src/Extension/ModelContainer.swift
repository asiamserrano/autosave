//
//  ModelContainer.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContainer {
    
    public static var models: [any PersistentModel.Type] = [
        // details for game
        GameModel.self,
//        Item.self
//        // used for viewing/modifying game
//        PropertyModel.self,
//        LinkModel.self
//        // used for filtering game
//        TagModel.self,
//        // connection between game and tag or property
//        RelationshipModel.self
    ]
    
    private convenience init(memory: Bool) {
        do {
            let schema: Schema = .init(Self.models)
            let config: ModelConfiguration = .init(schema: schema, isStoredInMemoryOnly: memory)
            try self.init(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    public static let preview: ModelContainer = .init(memory: true)
 
}
