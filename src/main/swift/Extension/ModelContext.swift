//
//  ModelContext.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContext {
    
    public func remove(_ model: Persistor) -> Void {
        self.delete(model)
        self.store()
    }
    
    public func fetchCount(_ predicate: PropertyPredicate) -> Int {
        let desc: PropertyFetchDescriptor = .init(predicate: predicate)
        do {
            return try self.fetchCount(desc)
        } catch {
            print("cannot fetch count for \(desc) -> error: \(error)")
            return 0
        }
    }
    
//
//    public func fetchCount(_ status: GameStatusEnum) -> Int {
//        let desc: GameFetchDescriptor = .getByStatus(status)
//        do {
//            return try self.fetchCount(desc)
//        } catch {
//            print("error: \(error)")
//            return 0
//        }
//    }

    func move(_ game: GameModel, _ next: GameStatusEnum) -> Void {
        game.setStatus(next)
        self.store()
    }
    
    @discardableResult
    func save(_ original: GameSnapshot, _ builder: GameBuilder) -> GameResult {
        let current: GameSnapshot = builder.snapshot
        let composite: GameFetchDescriptor = .getByCompositeKey(current)
        let new: GameModel? = self.fetchModel(composite)
        let uuid: GameFetchDescriptor = .getByUUID(original)
        if let old: GameModel = self.fetchModel(uuid) {
            if let new: GameModel = new, old.uuid != new.uuid {
                return .init(new.snapshot, false, .edit)
            } else {
                old.updateFromSnapshot(current)
                self.store()
                return .init(current, true, .edit)
            }
        } else {
            if let new: GameModel = new {
                return .init(new.snapshot, false, .add)
            } else {
                let game: GameModel = .fromSnapshot(current)
                self.add(game)
                return .init(current, true, .add)
            }
        }
    }
    
//    @discardableResult
//    func save(_ current: GameSnapshot) -> GameResult {
//        let composite: GameFetchDescriptor = .getByCompositeKey(current)
//        let new: GameModel? = self.fetchModel(composite)
//        if let new: GameModel = new {
//            return .init(new.snapshot, false, .add)
//        } else {
//            let game: GameModel = .fromSnapshot(current)
//            self.add(game)
//            return .init(current, true, .add)
//        }
//    }
    
//    @discardableResult
//    public func save(_ snapshot: PropertySnapshot) -> PropertyModel {
//        let composite: PropertyFetchDescriptor = .getByCompositeKey(snapshot)
//        let result: PropertyModel? = self.fetchModel(composite)
//        if let result: PropertyModel = result {
//            return result
//        } else {
//            let property: PropertyModel = .fromSnapshot(snapshot)
//            self.add(property)
//            return property
//        }
//    }
    
    @discardableResult
    public func save(_ snapshot: GameSnapshot) -> Bool {
        let composite: GameFetchDescriptor = .getByCompositeKey(snapshot)
        if self.fetchModel(composite) == nil {
            let game: GameModel = .fromSnapshot(snapshot)
            self.add(game)
            return true
        }
        return false
    }
    
    @discardableResult
    public func save(_ snapshot: PropertySnapshot) -> Bool {
        let composite: PropertyFetchDescriptor = .getByCompositeKey(snapshot)
        if self.fetchModel(composite) == nil {
            let property: PropertyModel = .fromSnapshot(snapshot)
            self.add(property)
            return true
        }
        return false
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
    
    func fetchModel(_ desc: PropertyFetchDescriptor) -> PropertyModel? {
        fetchModels(desc).first
    }
    
    func fetchModels(_ desc: PropertyFetchDescriptor) -> [PropertyModel] {
        do {
            return try self.fetch(desc)
        } catch {
            print("error: \(error)")
            return .init()
        }
    }
    
    func add(_ model: Persistor) -> Void {
        self.insert(model)
        self.store()
    }
    
    func store() {
        do {
            try self.save()
        } catch let error {
            fatalError("error saving in model context: \(error.localizedDescription)")
        }
    }
    
}
