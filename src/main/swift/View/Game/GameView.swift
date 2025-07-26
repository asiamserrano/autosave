//
//  GameView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct GameView: View {
    
    private let input: Input
    
    init(_ model: GameModel) {
        self.input = .model(model)
    }
    
    init(_ status: GameStatusEnum) {
        self.input = .status(status)
    }
    
    var body: some View {
        switch input {
        case .model(let model):
            QueryRelationView(model)
        case .status(let status):
            BuilderView(status)
        }
    }
    
    private struct QueryRelationView: View {
        @Query var relations: [RelationModel]
        
        let model: GameModel
        
        init(_ model: GameModel) {
            let predicate: RelationPredicate = .getByGame(model.uuid)
            self._relations = .init(filter: predicate)
            self.model = model
        }
        
        var body: some View {
            QueryPropertyView(relations, model)
        }
    }
    
    private struct QueryPropertyView: View {
        
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
        
        @Environment(\.dismiss) private var dismiss
        
        @Environment(\.modelContext) private var modelContext
        
        @StateObject var builder: GameBuilder
        
        let isNewGame: Bool
        
        init(_ model: GameModel, _ relations: [RelationModel], _ properties: [PropertyModel]) {
            self._builder = .init(wrappedValue: .init(model, relations, properties))
            self.isNewGame = false
        }
        
        init(_ status: GameStatusEnum) {
            self._builder = .init(wrappedValue: .init(status))
            self.isNewGame = true
        }
        
        var body: some View {
            Form {
                GameImageView()
                BooleanView(isEditing, trueView: EditOnView, falseView: EditOffView)
                PropertiesView()
            }
            .navigationBarBackButtonHidden()
            .environment(\.editMode, $builder.editMode)
            .environmentObject(self.builder)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        boolean_action(isEditing, TRUE: {
                            // TODO: do the save logic
                        }, FALSE: self.toggleEditMode)
                    }, label: {
                        CustomText(self.topBarTrailingButton)
                    })
                    .disabled(builder.isDisabled)
                })
                
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        boolean_action(isEditing, TRUE: {
                           boolean_action(isNewGame, TRUE: self.exit, FALSE: {
                               self.builder.cancel()
                               self.toggleEditMode()
                           })
                        }, FALSE: self.exit)
                    }, label: {
                        BooleanView(isEditing, trueView: {
                            CustomText(.cancel)
                        }, falseView: {
                            HStack(alignment: .center, spacing: 5, content: {
                                IconView(.chevron_left, .blue)
                                CustomText(.back)
                            })
                        })
                    })
                })
                
            }
        }
        
        private func exit() -> Void {
            self.dismiss()
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
                Picker(ConstantEnum.property.rawValue, selection: $builder.tagType) {
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
    
    private enum Input {
        case model(GameModel)
        case status(GameStatusEnum)
    }
    
}

fileprivate struct PropertiesView: Gameopticable {
    
    @EnvironmentObject public var builder: GameBuilder
    
    var body: some View {
        OptionalView(tags.isNotEmpty) {
            BooleanView(isEditing, trueView: {
                OptionalObjectView(tags.get(tagType)) { element in
                    ElementView(element)
                }
            }, falseView: {
                ForEach(TagCategory.cases) { category in
                    OptionalObjectView(tags.get(category)) { element in
                        SectionWrapper(category) {
                            ElementView(element)
                        }
                    }
                }
            })
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

fileprivate struct ElementView: Gameopticable {
    
    @EnvironmentObject public var builder: GameBuilder
    
    @State var navigation: Bool = false
    @State var navigationEnum: NavigationEnum? = .none
    
    let element: Tags.Element
    
    init(_ element: Tags.Element) {
        self.element = element
    }
    
    var body: some View {
        BooleanView(isEditing, trueView: EditOnView, falseView: EditOffView)
            .navigationDestination(isPresented: $navigation, destination: {
                OptionalObjectView(self.navigationEnum, content: {
                    switch $0 {
                    case .property(let gameBuilder, let inputEnum, let array):
                        AddPropertyView(gameBuilder, inputEnum, array)
                    case .platform(let gameBuilder, let systemBuilder):
                        AddPlatformView(gameBuilder, systemBuilder)
                    }
                })
            })
    }
    
    @ViewBuilder
    private func EditOnView() -> some View {
        switch element {
        case .inputs(let inputs):
            OptionalObjectView(InputEnum.convert(tagType)) { input in
                OptionalObjectView(inputs.strings(input)) { strings in
                    ButtonSection("add \(input.rawValue.lowercased())", action: {
                        self.navigationEnum = .property(builder, input, strings)
                        self.navigation.toggle()
                    }, content: {
                        ForEach(strings, id:\.self) { string in
                            Text(string)
                                .tag(string)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let value: String = strings[index]
                                let builder: InputBuilder = .init(input, value)
                                let tag: TagBuilder = .input(builder)
                                self.delete(tag)
                            }
                        })
                    })
                }
            }
        case .modes:
            Section {
                ForEach(ModeEnum.cases) { mode in
                    HStack {
                        IconView(mode.icon)
                        Text(mode.rawValue)
                        Spacer()
                        ModeToggle(.mode(mode))
                    }
                }
            }
        case .platforms(let platforms):
            ButtonSection("add \(self.tagType.rawValue)", platforms.unused.isEmpty, action: {
                self.navigationEnum = .platform(builder, nil)
                self.navigation.toggle()
            }, content: {
                OptionalArrayView(platforms.enums) { systems in
                    ForEach(systems) { system in
                        OptionalArrayView(FormatEnum.cases) { formatEnums in
                            DisclosureGroup(content: {
                                ForEach(formatEnums) { formatEnum in
                                    OptionalArrayView(platforms.array(system, formatEnum)) { formats in
                                        DisclosureGroup(content: {
                                            ForEach(formats) { format in
                                                HStack(spacing: 15) {
                                                    IconView(.arrow_right, .blue)
                                                    Text(format.rawValue)
                                                }
                                            }
                                            .onDelete(perform: { indexSet in
                                                indexSet.forEach {
                                                    self.builder.tags.delete(system, formats[$0])
                                                }
                                            })
                                        }, label: {
                                            HStack {
                                                IconView(formatEnum.icon, .blue)
                                                Text(formatEnum.rawValue)
                                            }
                                        })
                                    }
                                }
                                .onDelete(perform: { indexSet in
                                    indexSet.forEach {
                                        self.builder.tags.delete(system, formatEnums[$0])
                                    }
                                })
                            }, label: {
                                Button(action: {
                                    self.navigationEnum = .platform(builder, system)
                                    self.navigation.toggle()
                                }, label: {
                                    HStack(alignment: .center, spacing: 10) {
                                        Text(system.rawValue)
                                            .foregroundColor(.blue)
                                        Spacer()
                                    }
                                })
                            })
                        }
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach {
                            self.builder.tags.delete(systems[$0])
                        }
                    })
                }
            })
        }
    }
    
    @ViewBuilder
    private func ModeToggle(_ mode: TagBuilder) -> some View {
        Toggle(String.defaultValue, isOn: .init(get: {
            self.tags.contains(mode)
        }, set: { newValue in
            if newValue {
                self.builder.tags.add(mode)
            } else {
                self.builder.tags.delete(mode)
            }
        }))
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
