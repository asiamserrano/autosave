//
//  GameView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct GameView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var builder: GameBuilder
    
    init(_ builder: GameBuilder) {
        self.builder = builder
    }
    
    var body: some View {
        Form {
            Section {
                FormattedView(.title, self.builder.title)
                FormattedView(.release_date, self.builder.release.long)
            }
            PropertiesView(self.builder)
        }
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: {
                    GameForm(self.builder)
                }, label: {
                    CustomText(.edit)
                })
            })
            
        }
    }
    
}

fileprivate struct PropertiesView: View {
    
    @Query var models: [RelationModel]
    
    init(_ builder: GameBuilder) {
        let predicate: RelationPredicate = .getByGame(builder)
        self._models = .init(filter: predicate)
    }
    
    
    
    var body: some View {
        RelationView(models)
    }

    private struct RelationView: View {

        @Query var properties: [PropertyModel]
        
        let relations: [RelationModel]

        init(_ models: [RelationModel]) {
            self.relations = models
            let predicate: PropertyPredicate = .getByRelations(models)
            let sort: [PropertySortDescriptor] = .defaultValue
            self._properties = .init(filter: predicate, sort: sort)
        }
        
        var snapshots: [TagSnapshot] {
            
            func getProperty(_ uuid: UUID) -> PropertyModel? {
                self.properties.first(where: { $0.uuid == uuid })
            }
            
            return self.relations.compactMap { relation in
                let type: RelationType = .init(relation.type_id)
                if let  key: PropertyModel = getProperty(relation.key_uuid) {
                    switch type {
                    case .tag(.platform):
                        if let value: PropertyModel = getProperty(relation.value_uuid) {
                            return .fromModel(key, value)
                        }
                    default:
                        return .fromModel(key)
                    }
                }
                return nil
            }
        }
        
        var body: some View {
            ForEach(TagType.cases) { type in
                let items: [TagSnapshot] = self.snapshots.filter { $0.key.builder.tag == type }
                if !items.isEmpty {
                    let count: Int = items.count
                    Section(type.rawValue) {
                        ForEach(0..<count, id:\.self) { index in
                            let snapshot: TagSnapshot = items[index]
                            let key: String = snapshot.key.builder.value.trim
                            switch type {
                            case .platform:
                                let value: String = snapshot.value.builder.value.trim
                                FormattedView(key, value)
                            default:
                                Text(key)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
//    private struct QueryView: View {
//
//        @Query var models: [PropertyModel]
//        
////        let uuids: [UUIDEnum]
//        let relations: [RelationSnapshot]
//
//        init(_ models: [RelationModel]) {
//            
//            self.relations = models.map { model in
//                let key: UUID = model.key_uuid
//                let value: UUID = model.value_uuid
//                if key == value {
//                    return .single(key)
//                } else {
//                    return .pair(key, value)
//                }
//            }
//            
//            self.relations = models
//            let predicate: PropertyPredicate = .getByRelations(models)
//            let sort: [PropertySortDescriptor] = .defaultValue
//            self._models = .init(filter: predicate, sort: sort)
//        }
//    
//        var body: some View {
//            
//            ForEach(TagType.cases) { type in
//                Section(type.rawValue) {
//                    let filtered: [RelationModel] = relations.filter { $0.label_id == type.id }
//                    ForEach(filtered) { f in
//                        
//                    }
//                }
//            }
//            
////            Section {
////                FormattedView("property models", models.count.description)
////                FormattedView("relation models", relations.count.description)
////                FormattedView("relation property uuids", relations.property_uuids.count.description)
////            }
////            
////            Section("properties") {
////                ForEach(models) { model in
////                    Text(model.uuid.short)
////                }
////            }
////            
////            Section("relations") {
////                ForEach(relations) { relation in
////                    DisclosureGroup(relation.uuid.short, content: {
////                        FormattedView("key", relation.key_uuid.short)
////                        FormattedView("value", relation.value_uuid.short)
////                    })
////                }
////            }
//            
//        }
//        
////        @ViewBuilder
////        public func UUIDView(_ uuid: UUIDEnum) -> some View {
////            switch uuid {
////            case .single(let u):
////                PropertyView(getProperty(u))
////            case .pair(let u1, let u2):
////                PropertyView(getProperty(u1), getProperty(u2))
////            }
////        }
////        
////        private func getProperty(_ uuid: UUID) -> PropertyModel? {
////            self.models.first(where: { $0.uuid == uuid })
////        }
////        
////        @ViewBuilder
////        public func PropertyView(_ prop1: PropertyModel?, _ prop2: PropertyModel? = nil) -> some View {
////            if let prop1: PropertyModel = prop1 {
////                if let prop2: PropertyModel = prop2 {
////                    FormattedView(prop1.value_trim, prop2.value_trim)
////                } else {
////                    let label: PropertyLabel = .init(prop1.label_id)
////                    FormattedView(label.rawValue, prop1.value_trim)
////                }
////            }
////        }
//        
//    }
    
    
//    private struct QueryView: View {
//        
//        @Query var models: [PropertyModel]
//        
//        let type: RelationBase
//        let uuid: UUID
//        
//        init(_ uuid: UUID, _ type: RelationBase) {
//            self.type = type
//            self.uuid = uuid
//            let predicate: PropertyPredicate = .getByUUID(uuid)
//            let sort: [PropertySortDescriptor] = .defaultValue
//            self._models = .init(filter: predicate, sort: sort)
//        }
//        
////        init(_ uuids: [UUID], _ type: RelationBase) {
////            self.type = type
////            let predicate: PropertyPredicate = .getByUUIDs(uuids)
////            let sort: [PropertySortDescriptor] = .defaultValue
////            self._models = .init(filter: predicate, sort: sort)
////        }
//        
//        var body: some View {
//            if models.isEmpty {
//                FormattedView(self.type.rawValue, self.uuid)
//            } else {
//                ForEach(models) { model in
//                    let snapshot: PropertySnapshot = model.snapshot
//                    FormattedView(snapshot.base.rawValue, snapshot.value_trim)
//                }
//            }
//            
////            if models.isEmpty {
////                Text("no models")
////            } else {
////                VStack(alignment: .leading) {
////
////                }
////            }
//        }
//    }
    
}
