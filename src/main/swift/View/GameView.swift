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
        
    let builder: GameBuilder
    
    init(_ builder: GameBuilder) {
        self.builder = builder
    }
    
    var body: some View {
        ForEach(TagType.cases) { type in
            RelationView(builder, type)
        }
    }
    
    private struct RelationView: View {
        
        @Query var relations: [RelationModel]
        
        let type: TagType

        init(_ builder: GameBuilder, _ type: TagType) {
            self.type = type
            let predicate: RelationPredicate = .getByGame(builder, type)
            self._relations = .init(filter: predicate)
        }
         
        var body: some View {
            PropertyView(relations, type)
        }
        
    }

    private struct PropertyView: View {

        @Query var properties: [PropertyModel]
        
        let relations: [RelationModel]
        let type: TagType

        init(_ models: [RelationModel], _ type: TagType) {
            self.relations = models
            self.type = type
            let predicate: PropertyPredicate = .getByRelations(models)
            self._properties = .init(filter: predicate, sort: .defaultValue)
        }
        
        var title: String {
            type.rawValue.pluralize()
        }
        
        var body: some View {
            OptionalView(relations) {
                switch type {
                case .input:
                    let values: String = properties.map { $0.value_trim }.joined(separator: ",\n")
                    FormattedView(title, values)
                case .mode:
                    SectionForEach(properties) { index in
                        let property: PropertyModel = properties[index]
                        let mode: ModeEnum = .init(property.value_canon)
                        HStack(alignment: .center, spacing: 10) {
                            IconView(mode.icon)
                            Text(mode.rawValue)
                        }
                    }
                case .platform:
                    // TODO: implement sorting for system to formats
                    SectionForEach(relations) { index in
                        let relation: RelationModel = relations[index]
                        if let key: PropertyModel = getProperty(relation.key_uuid),
                            let value: PropertyModel = getProperty(relation.value_uuid) {
                            FormattedView(key.value_trim, value.value_trim)
                        }
                    }
                }
            }
        }
  
        func getProperty(_ uuid: UUID) -> PropertyModel? {
            self.properties.first(where: { $0.uuid == uuid })
        }
        
        @ViewBuilder
        func SectionForEach(_ array: [Any], @ViewBuilder _ content: @escaping (Int) -> some View) -> some View {
            Section(title) {
                ForEach(0..<array.count, id:\.self, content: content)
            }
        }
        
    }
    
}
