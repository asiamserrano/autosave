//
//  ModelContext.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContext {
    
    public func fetchCount(_ status: GameStatusEnum) -> Int {
        let desc: GameFetchDescriptor = .getByStatus(status)
        do {
            return try self.fetchCount(desc)
        } catch {
            print("error: \(error)")
            return 0
        }
    }
    
    public func add(_ game: GameModel) -> Void {
        self.insert(game)
        self.store()
    }
    
    public func remove(_ game: GameModel) -> Void {
        self.delete(game)
        self.store()
    }


    func move(_ game: GameModel, _ next: GameStatusEnum) -> Void {
        game.setStatus(next)
        self.store()
    }
    
    // TODO: This is not working
    @discardableResult
    func save(_ current: GameSnapshot) -> GameModel {
        let composite: GameFetchDescriptor = .getByCompositeKey(current)
        let fetched: GameModel? = self.fetchModel(composite)
        if let fetched: GameModel = fetched {
            let updated: GameModel = fetched.setSnapshot(current)
            self.store()
            return updated
        } else {
            let game: GameModel = .fromSnapshot(current)
            self.add(game)
            return game
        }
    }
    
}

private extension ModelContext {
    
    func fetchModel(_ desc: GameFetchDescriptor) -> GameModel? {
        fetchModels(desc).first
    }
    
    func fetchModels(_ desc: GameFetchDescriptor) -> [GameModel] {
        do {
            return try self.fetch(desc)
        } catch {
            print("error: \(error)")
            return .init()
        }
    }
    
    func store() {
        do {
            try self.save()
        } catch let error {
            fatalError("error saving in model context: \(error.localizedDescription)")
        }
    }
    
}
