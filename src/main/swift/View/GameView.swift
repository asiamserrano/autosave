//
//  GameView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct GameView: View {
    
    @Query var relations: [RelationModel]
    
    let model: GameModel
    
    init(_ model: GameModel) {
        let predicate: RelationPredicate = .getByGame(model.uuid)
        self._relations = .init(filter: predicate)
        self.model = model
    }
    
    var body: some View {
        QueryView(relations, model)
    }
    
    private struct QueryView: View {
        
        @Query var properties: [PropertyModel]
        
        let relations: [RelationModel]
        let model: GameModel
        
        init(_ relations: [RelationModel], _ model: GameModel) {
            self.relations = relations
            let predicate: PropertyPredicate = .getByRelations(relations)
            self._properties = .init(filter: predicate, sort: .defaultValue)
            self.model = model
        }
        
        var body: some View {
            BuilderView(model, relations, properties)
        }
        
    }
    
    private struct BuilderView: Gameopticable {
        
        @Environment(\.modelContext) private var modelContext
        
        @ObservedObject var builder: GameBuilder
                
        init(_ model: GameModel, _ relations: [RelationModel], _ properties: [PropertyModel]) {
            self.builder = .init(model, relations, properties)
        }
        
        var body: some View {
            Form {
                GameImageView()
                BooleanView(isEditing, EditOnView, EditOffView)
                PropertiesView()
            }
            .environmentObject(self.builder)
            .environment(\.editMode, $builder.editMode)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: self.toggleEditMode, label: {
                        CustomText(self.topBarTrailingButton)
                    })
                })
                
            }
        }
        
        @ViewBuilder
        private func EditOnView() -> some View {
            Section {
                CustomTextField(.title, $builder.title)
            }
            Section {
                CustomDatePicker(.release_date, $builder.release)
            }
            
            Section {
                Picker("Property", selection: $builder.tagType) {
                    ForEach(TagType.cases) { tag in
                        Text(tag.rawValue)
                            .tag(tag)
                    }
                }
                .pickerStyle(.menu)
            }
            
        }
        
        @ViewBuilder
        private func EditOffView() -> some View {
            Section {
                FormattedView(.title, self.title)
                FormattedView(.release_date, self.release.long)
            }
        }
        
    }
    
}

fileprivate struct PropertiesView: Gameopticable {
    
    @EnvironmentObject public var builder: GameBuilder
    
    var body: some View {
        OptionalView(!tags.isEmpty) {
            BooleanView(isEditing, EditOnView, EditOffView)
        }
    }
    
    @ViewBuilder
    private func EditOnView() -> some View {
        OptionalObjectView(tags.category(tagType.category)) { element in
            ElementView(element)
        }
    }
    
    @ViewBuilder
    private func EditOffView() -> some View {
        ForEach(TagCategory.cases) { category in
            OptionalObjectView(tags.category(category)) { element in
                SectionWrapper(category) {
                    ElementView(element)
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
    
}

fileprivate struct ElementView: Gameopticable, Configurable {
    
    @EnvironmentObject public var configuration: Configuration
    @EnvironmentObject public var builder: GameBuilder
        
    let element: Tags.Element

    init(_ element: Tags.Element) {
        self.element = element
    }
    
    var body: some View {
        BooleanView(isEditing, EditOnView, EditOffView)
    }
 
    @ViewBuilder
    private func EditOnView() -> some View {
        switch element {
        case .inputs(let inputs):
            OptionalObjectView(InputEnum.convert(tagType)) { input in
                OptionalObjectView(inputs.strings(input)) { strings in
                    Section(content: {
                        ForEach(strings, id:\.self) { string in
                            Text(string)
                                .tag(string)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let builder: InputBuilder = .init(input, strings[index])
                                self.delete(.input(builder))
                            }
                        })
                    }, header: {
                        Button(action: {
//                            self.setNavigation(builder, input, strings)
                        }, label: {
                            HStack(alignment: .center, spacing: 17) {
                                IconView(.plus_circle_fill, 22, 22, .green)
                                Text("add \(input.rawValue.lowercased())")
                            }
                            .padding(.leading, 1)
                        })
                        .padding(.bottom, 8)
                    })
                    .textCase(nil)
                }

            }
        default:
            EmptyView()
        }
       
    }
    
    @ViewBuilder
    private func EditOffView() -> some View {
        switch element {
        case .inputs(let inputs):
            ForEach(inputs.enums) { key in
                OptionalObjectView(inputs.string(key)) { value in
                    FormattedView(key.rawValue.pluralize(), value)
                }
            }
        case .modes(let modes):
            ForEach(modes.enums) { mode in
                HStack(alignment: .center, spacing: 10) {
                    IconView(mode.icon)
                    Text(mode.rawValue)
                }
            }
        case .platforms(let platforms):
            ForEach(platforms.enums) { system in
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
