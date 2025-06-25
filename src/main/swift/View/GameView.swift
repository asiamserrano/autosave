//
//  GameView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct GameView: Gameopticable {
    
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var builder: GameBuilder
    
    
    
    init(_ builder: GameBuilder) {
        self.builder = builder
    }
    
    var body: some View {
        Form {
            GameImageView(false)
            Section {
                FormattedView(.title, self.title)
                FormattedView(.release_date, self.release.long)
            }
            PropertiesView()
        }
        .environmentObject(self.builder)
//        .environment(\.editMode, $builder.editMode)
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

fileprivate struct PropertiesView: Gameopticable {
    
    @EnvironmentObject public var builder: GameBuilder
    
    var body: some View {
        RelationView(builder)
    }
    
    private struct RelationView: View {
        
        @Query var relations: [RelationModel]
        
        init(_ builder: GameBuilder) {
            let predicate: RelationPredicate = .getByGame(builder)
            self._relations = .init(filter: predicate)
        }
        
        var body: some View {
            PropertyView(relations)
        }
        
    }
    
    private struct PropertyView: View {
        
        private typealias Tags = TagsMap
        
        @Query var properties: [PropertyModel]
        
        let relations: [RelationModel]
        
        init(_ relations: [RelationModel]) {
            self.relations = relations
            let predicate: PropertyPredicate = .getByRelations(relations)
            self._properties = .init(filter: predicate, sort: .defaultValue)
        }
        
        var body: some View {
            EmptyView()
        }
        // TODO: Fix this
//        var body: some View {
//            if let map: Tags = .fromModels(relations, properties) {
//                
//                ForEach(Tags.Category.cases) { cat in
//                    switch map.get(cat) {
//                    case .inputs(let inputs):
//                        
//                    }
//                }
//                
//            }
//            
//        }
//        
//        @ViewBuilder
//        private func InputsView(_ inputs: Tags.Inputs) -> some View {
//            ForEach(inputs.k)
//        }
        
    }

//    private struct PropertyView: View {
//
//        @Query var properties: [PropertyModel]
//        
//        let relations: [RelationModel]
//        let type: TagType
//
//        init(_ models: [RelationModel], _ type: TagType) {
//            self.relations = models
//            self.type = type
//            let predicate: PropertyPredicate = .getByRelations(models)
//            self._properties = .init(filter: predicate, sort: .defaultValue)
//        }
//        
//        var title: String {
//            type.rawValue.pluralize()
//        }
//        
//        var body: some View {
//            OptionalView(relations) {
//                switch type {
//                case .input:
//                    let values: String = properties.map { $0.value_trim }.joined(separator: ",\n")
//                    FormattedView(title, values)
//                case .mode:
//                    let modes: [ModeEnum] = properties.map { .init($0.value_canon) }
//                    OptionalArrayView(modes) { modes in
//                        Section(title) {
//                            ForEach(modes) { mode in
//                                HStack(alignment: .center, spacing: 10) {
//                                    IconView(mode.icon)
//                                    Text(mode.rawValue)
//                                }
//                            }
//                        }
//                    }
//                case .platform:
//                    let builders: [PlatformBuilder] = .init(relations, properties)
//                    let map: [SystemBuilder: [FormatBuilder]] = .init(builders)
//                    OptionalArrayView(map.sortedKeys) { systems in
//                        Section(title) {
//                            ForEach(systems) { system in
//                                let formats: [FormatBuilder] = map.getOrDefault(system)
//                                PlatformLabel(system, formats)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        
//        @ViewBuilder
//        func PlatformLabel(_ system: SystemBuilder, _ formats: [FormatBuilder]) -> some View {
//            OptionalArrayView(formats) { formats in
//                OrientationStack(.vstack) {
//                    Text(system.rawValue)
//                        .bold()
//                    FormatsView(formats)
//                }
//            }
//        }
//        
//        @ViewBuilder
//        func FormatsView(_ group: [FormatBuilder]) -> some View {
//            OptionalArrayView(group.keys) { keys in
//                OrientationStack(.hstack) {
//                    ForEach(keys) { key in
//                        OptionalArrayView(group.filter(key)) { formats in
//                            OrientationStack(.hstack) {
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
//        
//    }
    
    
    
}
