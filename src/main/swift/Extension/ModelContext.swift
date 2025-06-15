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
    
    @discardableResult
    public func save(_ snapshot: PropertySnapshot) -> PropertyModel? {
        let composite: PropertyFetchDescriptor = .getByCompositeKey(snapshot)
        if self.fetchModel(composite) == nil {
            let property: PropertyModel = .fromSnapshot(snapshot)
            self.add(property)
            return property
        }
        return nil
    }
    
//    @discardableResult
//    public func save(_ snapshot: RelationSnapshot) -> RelationModel? {
//        let composite: RelationFetchDescriptor = .getByCompositeKey(snapshot)
//        if let model: RelationModel = self.fetchModel(composite) {
//            let type: RelationBase = model.type
//            if type.isIncrementable {
//                model.increment()
//                self.store()
//            }
//            return nil
//        } else {
//            let relation: RelationModel = .fromSnapshot(snapshot)
//            self.add(relation)
//            return relation
//        }
//    }
//
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
//    
//    func fetchModel(_ desc: RelationFetchDescriptor) -> RelationModel? {
//        fetchModels(desc).first
//    }
//    
//    func fetchModels(_ desc: RelationFetchDescriptor) -> [RelationModel] {
//        do {
//            return try self.fetch(desc)
//        } catch {
//            print("error: \(error)")
//            return .init()
//        }
//    }
    
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

