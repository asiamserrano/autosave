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
        
        @Query var properties: [PropertyModel]
        
        let relations: [RelationModel]
        
        init(_ relations: [RelationModel]) {
            self.relations = relations
            let predicate: PropertyPredicate = .getByRelations(relations)
            self._properties = .init(filter: predicate, sort: .defaultValue)
        }
        
        var body: some View {
            TagsView(relations, properties)
        }
        
    }
    
    private struct TagsView: View {
        
        private typealias Tags = TagsMap
        
        let tags: TagsMap
        
        init(_ relations: [RelationModel], _ properties: [PropertyModel]) {
            self.tags = .build(relations, properties)
        }
        
        var body: some View {
            OptionalView(!tags.isEmpty) {
                ForEach(TagCategory.cases) { category in
                    OptionalObjectView(tags.category(category)) { element in
                        SectionWrapper(category) {
                            switch element {
                            case .inputs(let inputs):
                                ForEach(inputs.keys) { key in
                                    OptionalObjectView(inputs.string(key)) { value in
                                        FormattedView(key.rawValue.pluralize(), value)
                                    }
                                }
                            case .modes(let modes):
                                ForEach(modes.keys) { mode in
                                    HStack(alignment: .center, spacing: 10) {
                                        IconView(mode.icon)
                                        Text(mode.rawValue)
                                    }
                                }
                            case .platforms(let platforms):
                                ForEach(platforms.keys) { system in
                                    OptionalArrayView(platforms.array(system)) { formats in
                                        OrientationStack(.vstack) {
                                            Text(system.rawValue)
                                                .bold()
                                            FormatsView(formats)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        @ViewBuilder
        private func SectionWrapper(_ category: TagCategory, @ViewBuilder _ content: @escaping () -> some View) -> some View {
            switch category {
            case .input:
                Section(content: content)
            default:
                Section(category.rawValue.pluralize(), content: content)
            }
        }
 
        @ViewBuilder
        private func FormatsView(_ group: [FormatBuilder]) -> some View {
            OptionalArrayView(group.keys) { keys in
                OrientationStack(.hstack) {
                    ForEach(keys) { key in
                        OptionalArrayView(group.filter(key)) { formats in
                            OrientationStack(.hstack) {
                                IconView(key.icon, 16)
                                Text(formats.joined)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                }
            }
        }
        
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
