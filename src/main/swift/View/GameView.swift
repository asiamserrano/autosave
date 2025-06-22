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
                    let builders: [PlatformBuilder] = .init(relations, properties)
                    OptionalView(builders) {
                        let map: [SystemBuilder: [FormatBuilder]] = .init(builders)
                        let systems: [SystemBuilder] = map.systems
                        SectionForEach(systems) { index in
                            let system: SystemBuilder = systems[index]
                            let formats: [FormatBuilder] = map.getOrDefault(system)
                            PlatformLabel(system, formats)
                        }
                    }
                    
//                    if let systems: [SystemBuilder] = map.systems.optional {
//                        SectionForEach(systems) { index in
//                            let system: SystemBuilder = systems[index]
//                            PlatformLabel(system, map[system])
//                        }
//                    }
                }
            }
        }
        
        @ViewBuilder
        func SectionForEach(_ array: [Any], @ViewBuilder _ content: @escaping (Int) -> some View) -> some View {
            Section(title) {
                ForEach(0..<array.count, id:\.self, content: content)
            }
        }
        
        @ViewBuilder
        func PlatformLabel(_ system: SystemBuilder, _ formats: [FormatBuilder]) -> some View {
            OptionalView(formats) {
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(system.rawValue)
                                .bold()
                            FormatsView(formats)
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        IconView(.chevron_right, .blue)
                    }
//                    .show(self.isEditing)
                }
            }
        }
        
//        @ViewBuilder
//        func FormatsView(_ group: [FormatBuilder]) -> some View {
//            OptionalArrayView(group.keys) { keys in
//                HStack(alignment: .center) {
//                    ForEach(keys) { key in
//                        OptionalArrayView(group.filter(key)) { formats in
//                            HStack {
//                                IconView(key.icon, 16)
//                                Text(formats.joined)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                    .italic()
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        @ViewBuilder
        func FormatsView(_ group: [FormatBuilder]) -> some View {
            OptionalArrayView(group.keys, .elements({ keys in
                HStack(alignment: .center) {
                    ForEach(keys) { key in
                        OptionalArrayView(group.filter(key), .elements({ formats in
                            HStack {
                                IconView(key.icon, 16)
                                Text(formats.joined)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }))
                    }
                }
            }))
        }
        
    }
    
    
    
}
