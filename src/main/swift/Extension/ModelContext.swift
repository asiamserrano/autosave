//
//  ModelContext.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

extension ModelContext {
    
    public func fetchCount(_ model: ModelEnum) -> Int {
        switch model {
        case .game:
            let desc: GameFetchDescriptor = .init(predicate: .true)
            return (try? self.fetchCount(desc)) ?? 0
        case .property:
            let desc: PropertyFetchDescriptor = .init(predicate: .true)
            return (try? self.fetchCount(desc)) ?? 0
        case .relation:
            let desc: RelationFetchDescriptor = .init(predicate: .true)
            return (try? self.fetchCount(desc)) ?? 0
        }
    }
    
    public func remove(_ model: Persistor) -> Void {
        self.delete(model)
        self.store()
    }
    
    func move(_ game: GameModel, _ next: GameStatusEnum) -> Void {
        game.setStatus(next)
        self.store()
    }
    
    
    
//    @discardableResult
//    func save(_ original: GameSnapshot, _ builder: GameBuilder) -> GameResult {
//        let current: GameSnapshot = builder.snapshot
//        let composite: GameFetchDescriptor = .getByCompositeKey(current)
//        let new: GameModel? = self.fetchModel(composite)
//        let uuid: GameFetchDescriptor = .getByUUID(original)
//        if let old: GameModel = self.fetchModel(uuid) {
//            if let new: GameModel = new, old.uuid != new.uuid {
//                return .init(new.snapshot, false, .edit)
//            } else {
//                old.updateFromSnapshot(current)
//                self.store()
//                return .init(current, true, .edit)
//            }
//        } else {
//            if let new: GameModel = new {
//                return .init(new.snapshot, false, .add)
//            } else {
//                let game: GameModel = .fromSnapshot(current)
//                self.add(game)
//                return .init(current, true, .add)
//            }
//        }
//    }
    
    @discardableResult
    public func save(_ snapshot: GameSnapshot) -> GameModel? {
        let composite: GameFetchDescriptor = .getByCompositeKey(snapshot)
        if self.fetchModel(composite) == nil {
            let game: GameModel = .fromSnapshot(snapshot)
            self.add(game)
            return game
        }
        return nil
    }
    
    
    private func save(_ snapshot: PropertySnapshot) -> PropertyModel {
        if let existing: PropertyModel = self.fetchModel(snapshot) {
            return existing
        } else {
            let property: PropertyModel = .fromSnapshot(snapshot)
            self.add(property)
            return property
        }
    }
    
    private func save(_ category: RelationCategory, _ game: GameModel, _ tag: TagSnapshot) -> Void {
        let snapshot: RelationSnapshot = .init(category, game, tag)
        if self.fetchModel(snapshot) == nil {
            let relation: RelationModel = .fromSnapshot(snapshot)
            self.add(relation)
        }
    }
 
    public func save(_ game: GameModel, _ builder: TagBuilder) -> Void {
        let key: PropertyModel = save(builder.key)
        switch builder {
        case .platform:
            let value: PropertyModel = save(builder.value)
            save(.tag, game, .fromModel(key, value))
            save(.property, game, .fromModel(key))
            save(.property, game, .fromModel(value))
        default:
            let snapshot: TagSnapshot = .fromModel(key)
            save(.tag, game, snapshot)
            save(.property, game, snapshot)
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
    
//    func fetchModel(_ desc: PropertyFetchDescriptor) -> PropertyModel? {
//        fetchModels(desc).first
//    }
    
    func fetchModel(_ snapshot: PropertySnapshot) -> PropertyModel? {
        let composite: PropertyFetchDescriptor = .getByCompositeKey(snapshot)
        return fetchModels(composite).first
    }
    
    func fetchModels(_ desc: PropertyFetchDescriptor) -> [PropertyModel] {
        do {
            return try self.fetch(desc)
        } catch {
            print("error: \(error)")
            return .init()
        }
    }
    
//    func fetchModel(_ desc: RelationFetchDescriptor) -> RelationModel? {
//        fetchModels(desc).first
//    }
//    
    func fetchModel(_ snapshot: RelationSnapshot) -> RelationModel? {
        let composite: RelationFetchDescriptor = .getByCompositeKey(snapshot)
        return fetchModels(composite).first
    }
    
    func fetchModels(_ desc: RelationFetchDescriptor) -> [RelationModel] {
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

