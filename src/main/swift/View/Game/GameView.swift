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
        
        @Environment(\.modelContext) private var modelContext
        
        @StateObject var builder: GameBuilder
        
        init(_ model: GameModel, _ relations: [RelationModel], _ properties: [PropertyModel]) {
            self._builder = .init(wrappedValue: .init(model, relations, properties))
        }
        
        init(_ status: GameStatusEnum) {
            self._builder = .init(wrappedValue: .init(status))
        }
        
        var body: some View {
            
            //            Form {
            //                Section {
            //                    Text(self.builder.title)
            //                    Text(self.builder.release.long)
            //                }
            //            }
            //            .navigationDestination(isPresented: $navigation, destination: {
            //                Text("navigated")
            //            })
            //            .toolbar {
            //
            //                ToolbarItem(placement: .topBarTrailing) {
            //                    Button(action: {
            //                        self.navigation.toggle()
            //                    }, label: {
            //                        Text("Navigate")
            //                    })
            //                }
            //
            //                ToolbarItem(placement: .topBarTrailing) {
            //                    Button(action: {
            //                        self.navigation.toggle()
            //                    }, label: {
            //                        Text("Navigate")
            //                    })
            //                }
            //
            //            }
            
            
            Form {
                GameImageView()
                BooleanView(isEditing, trueView: EditOnView, falseView: EditOffView)
                PropertiesView()
            }
            .environment(\.editMode, $builder.editMode)
            .environmentObject(self.builder)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: self.toggleEditMode, label: {
                        CustomText(self.topBarTrailingButton)
                    })
                    .disabled(builder.isDisabled)
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
                OptionalObjectView(tags.category(tagType.category)) { element in
                    ElementView(element)
                }
            }, falseView: {
                ForEach(TagCategory.cases) { category in
                    OptionalObjectView(tags.category(category)) { element in
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
    
    // TODO: set the back button to 'Cancel'
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
            // TODO: fix the 'add' button not showing if platforms is empty
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
    
    
    //    @ViewBuilder
    //    private func FormatsView(_ platform: PlatformBuilder, _ format: FormatEnum, _ mapper: FormatMapper) -> some View {
    //        let values: [FormatBuilder] = mapper.get(format)
    //        if values.isNotEmpty {
    //            DisclosureGroup(
    //                content: {
    //                    ForEach(values, id:\.hashValue) { item in
    //                        HStack(spacing: 15) {
    //                            IconView("arrow.right", .blue)
    //                            Text(item.value.display)
    //                        }
    //                    }
    //                    .onDelete(perform: { indexSet in
    //                        indexSet.forEach {
    //                            let new: PlatformMapper = self.platforms.delete(platform, values[$0])
    //                            self.viewer.setPlatforms(new)
    //                        }
    //                    })
    //                },
    //                label: {
    //                    HStack {
    //                        IconView(format.icon, .blue)
    //                        Text(format.display)
    //                    }
    //                }
    //            )
    //        }
    //    }
    
    //    @ViewBuilder
    //    func PlatformsView() -> some View {
    //
    //        OptionalArrayView(self.tags.platforms.builders) { platforms in
    //            ForEach(platforms) { platform in
    //                Button(action: {
    //                    self.videogame.setPlatform(platform)
    //                }, label: {
    //                    PlatformLabel(platform)
    //                })
    //            }
    //            .onDelete(perform: { indexSet in
    //                indexSet.forEach { index in
    //                    let platform: PlatformBuilder = platforms[index]
    //                    self.builder.tags.delete(.platform(platform))
    //                }
    //            })
    //        }
    //
    //
    //    }
    //
    //    @ViewBuilder
    //    func PlatformsView(_ title: String, _ disabled: Bool) -> some View {
    //        ButtonSection(title, disabled, action: {
    //            self.videogame.setPlatform()
    //        }, content: {
    //            PlatformsView()
    //        })
    //    }
    //
    //    @ViewBuilder
    //    func PlatformLabel(_ platform: PlatformBuilder) -> some View {
    //        if let formats: FormatBuilders = self.videogame.get(platform).optional {
    //            ZStack {
    //                HStack {
    //                    VStack(alignment: .leading) {
    //                        Text(platform.display)
    //                            .bold()
    //                        FormatsView(formats)
    //                    }
    //                    Spacer()
    //                }
    //                HStack {
    //                    Spacer()
    //                    IconView("chevron.right", .blue)
    //                }
    //                .show(self.isEditing)
    //            }
    //        }
    //    }
    
}
