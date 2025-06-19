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
    
    public func fetchCount(_ predicate: PropertyPredicate?) -> Int {
        let desc: PropertyFetchDescriptor = .init(predicate: predicate)
        let int: Int? = try? self.fetchCount(desc)
        return int ?? 0
    }

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
    public func save(_ snapshot: GameSnapshot) -> GameModel? {
        let composite: GameFetchDescriptor = .getByCompositeKey(snapshot)
        if self.fetchModel(composite) == nil {
            let game: GameModel = .fromSnapshot(snapshot)
            self.add(game)
            return game
        }
        return nil
    }
    
    
    private func save(_ snapshot: PropertySnapshot) -> (PropertyModel, Int) {
        if let existing: PropertyModel = self.fetchModel(snapshot) {
            return (existing, 0)
        } else {
            let property: PropertyModel = .fromSnapshot(snapshot)
            self.add(property)
            return (property, 1)
        }
    }
    
    private func save(_ type: RelationType, _ game: GameModel, _ tag: TagSnapshot) -> Void {
        let snapshot: RelationSnapshot = .init(type, game, tag)
        if self.fetchModel(snapshot) == nil {
            let relation: RelationModel = .fromSnapshot(snapshot)
            self.add(relation)
        }
    }
    
    @discardableResult
    public func save(_ game: GameModel, _ builder: TagBuilder) -> Int {
        let property: PropertySnapshot = builder.key
        switch builder {
        case .platform:
            let res1: (PropertyModel, Int) = save(property)
            let res2: (PropertyModel, Int) = save(builder.value)
            let key: PropertyModel = res1.0
            let value: PropertyModel = res2.0
            save(.tag, game, .fromModel(key, value))
            save(.property, game, .fromModel(key))
            save(.property, game, .fromModel(value))
            return res1.1 + res2.1
        default:
            let result: (PropertyModel, Int) = save(property)
            let snapshot: TagSnapshot = .fromModel(result.0)
            save(.tag, game, snapshot)
            save(.property, game, snapshot)
            return result.1
        }
    }
    
    
    
//    @discardableResult
//    public func save(_ game: GameModel, _ property: PropertySnapshot) -> Int {
//        let result: (PropertyModel, Int) = save(property)
//        let snapshot: RelationSnapshot = .build(game, result.0)
//        if self.fetchModel(snapshot) == nil {
//            let relation: RelationModel = .fromSnapshot(snapshot)
//            self.add(relation)
//        }
//        
//        return result.1
//    }

//    @discardableResult
//    private func save(_ snapshot: PropertySnapshot) -> Int {
//        let composite: PropertyFetchDescriptor = .getByCompositeKey(snapshot)
//        if self.fetchModel(composite) == nil {
//            let property: PropertyModel = .fromSnapshot(snapshot)
//            self.add(property)
//            return 1
//        } else {
//            return 0
//        }
//    }
    
    
//    // TODO: Fix this save method, the property snapshots are not staying consistent with the relations and properties models
//    public func save(_ game: GameModel, _ builder: RelationBuilder) -> Int {
//        var count: Int = 0
//        
//        func doSave(_ p: PropertySnapshot) -> Void {
//            let result: PropertyResult = save(p)
//            count += result.successful ? 1 : 0
//            let snapshot: RelationSnapshot = .fromSnapshot(game, p)
//            save(snapshot)
//        }
//        
//        switch builder {
//        case .property(let p):
//            doSave(p)
//        case .platform(let p1, let p2):
//            doSave(p1)
//            doSave(p2)
//            let snapshot: RelationSnapshot = .fromBuilder(game, builder)
//            save(snapshot)
//        }
//        
//        
////        builder.array.map { RelationSnapshot.fromBuilder(model, $0) }.forEach { save($0) }
////        [PropertySnapshot].init(builder).map { save($0) }.forEach { count += $0 == nil ? 0 : 1 }
//        return count
//    }
    
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

