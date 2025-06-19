//
//  GameView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

extension UUID {
    
    public var short: String {
        self.uuidString.components(separatedBy: "-")[4]
    }
    
}

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
        QueryView(models)
    }
    
    private enum UUIDEnum: Identifiable, Hashable {
        case single(UUID)
        case pair(UUID, UUID)
        
        public var id: String {
            switch self {
            case .single(let u):
                return getID(u)
            case .pair(let u1, let u2):
                return getID(u1, u2)
            }
        }
        
        private func getID(_ u1: UUID, _ u2: UUID? = nil) -> String {
            let u1: String = u1.uuidString
            let u2: String = u2?.uuidString ?? u1
            return "\(u1)||\(u2)"
        }
        
    }

    private struct QueryView: View {

        @Query var models: [PropertyModel]
        
        let uuids: [UUIDEnum]
        let relations: [RelationModel]

        init(_ models: [RelationModel]) {
            
            self.uuids = models.map { model in
                let key: UUID = model.key_uuid
                let value: UUID = model.value_uuid
                if key == value {
                    return .single(key)
                } else {
                    return .pair(key, value)
                }
            }
            
            self.relations = models
            let predicate: PropertyPredicate = .getByRelations(models)
            let sort: [PropertySortDescriptor] = .defaultValue
            self._models = .init(filter: predicate, sort: sort)
        }
    
        var body: some View {
//            Section {
//                FormattedView("relation models", relations.count.description)
//                FormattedView("relation property uuids", relations.property_uuids.count.description)
//            }
//            
//            Section("properties") {
//                ForEach(models) { model in
//                    Text(model.uuid.short)
//                }
//            }
//            
//            Section("relations") {
//                ForEach(relations) { relation in
//                    DisclosureGroup(relation.uuid.short, content: {
//                        FormattedView("key", relation.key_uuid.short)
//                        FormattedView("value", relation.value_uuid.short)
//                    })
//                }
//            }
            
            Section {
                ForEach(uuids, content: UUIDView)
            }
        }
        
        @ViewBuilder
        public func UUIDView(_ uuid: UUIDEnum) -> some View {
            switch uuid {
            case .single(let u):
                PropertyView(getProperty(u))
            case .pair(let u1, let u2):
                PropertyView(getProperty(u1), getProperty(u2))
            }
        }
        
        private func getProperty(_ uuid: UUID) -> PropertyModel? {
            self.models.first(where: { $0.uuid == uuid })
        }
        
        @ViewBuilder
        public func PropertyView(_ prop1: PropertyModel?, _ prop2: PropertyModel? = nil) -> some View {
            if let prop1: PropertyModel = prop1 {
                if let prop2: PropertyModel = prop2 {
                    FormattedView(prop1.value_trim, prop2.value_trim)
                } else {
                    let label: PropertyLabel = .init(prop1.label_id)
                    FormattedView(label.rawValue, prop1.value_trim)
                }
            }
        }
        
    }
    
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
