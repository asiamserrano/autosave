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
//            PropertiesView(self.builder)
        }
        .onAppear {
            print("game \(self.builder.uuid)")
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

//fileprivate struct PropertiesView: View {
//    
//    @Query var models: [RelationModel]
//    
//    init(_ builder: GameBuilder) {
//        let uuid: UUID = builder.uuid
//        let predicate: RelationPredicate = .getByGame(uuid)
//        self._models = .init(filter: predicate)
//    }
//    
//    var relations: [RelationBase] {
//        RelationBase.cases.filter { !PlatformBase.contains($0) }
//    }
//    
//    var properties: [UUID] {
//        self.models.flatMap { model in
//            let set: Set<UUID> = .init(arrayLiteral: model.property_key_uuid, model.property_value_uuid)
//            return set.sorted()
//        }
//    }
//    
//    var body: some View {
//        Section {
//            ForEach(models, id: \.self) { model in
//                
//                
////                QueryView(uuid)
//                
//                let key: UUID = model.property_key_uuid
//                let value: UUID = model.property_value_uuid
//                
//                if key == value {
//                    QueryView(key)
//                }
//                
//////                let uuids: [UUID] = key == value ? .init(key) : .init(key, value)
////                
////                let type: RelationBase = .init(model.type_id)
////                LeadingVStack {
////                    if key == value {
//////                        Text("key: \(key.uuidString)")
////                        QueryView(key, type)
////                    } else {
////                        Text("key: \(key.uuidString)")
////                        Text("value: \(value.uuidString)")
////                    }
////                }
//                
//                
//                
////                QueryView(uuids)
//                
//                
////                let type: RelationBase = .init(model.type_id)
////                
////                
////                
////                if relations.contains(type) {
////                    VStack(alignment: .leading) {
////                        let key: UUID = model.property_key_uuid
////                        switch type {
////                        case .platform:
//////                            Text("Platform")
////                            QueryView(key)
////                            QueryView(model.property_value_uuid)
////                        default:
////                            QueryView(key)
////                        }
//////                        FormattedView("type", type.rawValue)
//////                        let key: UUID = model.property_key_uuid
//////                        let value: UUID = model.property_value_uuid
//////                        if key == value {
//////                            FormattedView("property", key)
//////                        } else {
//////                            FormattedView("system", key)
//////                            FormattedView("format", value)
//////                        }
////                    }
////                }
//            }
//        }
//    }
//    
//    private struct QueryView: View {
//        
//        @Query var models: [PropertyModel]
//        
////        let type: RelationBase
//        let uuid: UUID
//        
//        init(_ uuid: UUID) {
////            self.type = type
//            self.uuid = uuid
//            let predicate: PropertyPredicate = .getByUUID(uuid)
//            let sort: [PropertySortDescriptor] = .defaultValue
//            self._models = .init(filter: predicate, sort: sort)
//        }
//        
//        var body: some View {
//            if models.count == 1, let model: PropertyModel = models.first {
//                let snapshot: PropertySnapshot = model.snapshot
//                FormattedView(snapshot.base.rawValue, snapshot.value_trim)
//            } else {
//                FormattedView("unknown", self.uuid)
//            }
//        }
//    }
//    
//}
