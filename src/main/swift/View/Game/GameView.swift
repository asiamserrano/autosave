////
////  GameView.swift
////  autosave
////
////  Created by Asia Michelle Serrano on 5/7/25.
////
//
import SwiftUI
import SwiftData

//struct GameView: View {
//
//    let string: String
//
//    init(_ model: GameModel) {
//        self.string = "model"
//    }
//
//    init(_ status: GameStatusEnum) {
//        self.string = "status"
//    }
//
//    var body: some View {
//        Text(self.string)
//    }
//
//}

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
                
                //1
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        // TODO: do the save logic
                        self.toggleEditMode()
//                        boolean_action(isEditing, TRUE: {
//                            self.builder.save()
//                            self.modelContext.save(self.builder)
//                            self.toggleEditMode()
//                        }, FALSE: self.toggleEditMode)
                    }, label: {
                        CustomText(self.topBarTrailingButton)
                    })
                    .disabled(builder.isDisabled)
                })
                
                //2
                
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
        
        private func exit() -> Void {
            self.dismiss()
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
        QuantifiableView(tags) { tags in
            BooleanView(isEditing, trueView: {
                WrapperView(tags.get(tagType)) { element in
                    ElementView(element)
                }
            }, falseView: {
                ForEach(TagCategory.cases) { category in
                    QuantifiableView(tags.get(category)) { element in
                        SectionWrapper(category, {
                            ElementView(element)
                        })
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
    
    typealias Element = TagContainer.Element
    
    @EnvironmentObject public var builder: GameBuilder
    
    @State var navigation: Bool = false
    @State var navigationEnum: NavigationEnum? = .none
    
    let element: Element
    
    init(_ element: Element) {
        self.element = element
    }
    
    var body: some View {
        BooleanView(isEditing, trueView: EditOnView, falseView: EditOffView)
            .navigationDestination(isPresented: $navigation, destination: {
                OptionalView(self.navigationEnum) { nav in
                    switch nav {
                    case .property(let gameBuilder, let inputEnum, let array):
                        AddPropertyView(gameBuilder, inputEnum, array)
                    case .platform(let gameBuilder, let systemBuilder):
                        AddPlatformView(gameBuilder, systemBuilder)
                    }
                }
            })
    }
    
    @ViewBuilder
    private func EditOffView() -> some View {
        switch element {
        case .inputs(let inputs):
            SortedSetView(inputs.keys) { key in
                QuantifiableView(inputs.get(key).joined) { value in
                    FormattedView(key.rawValue.pluralize(), value)
                }
            }
        case .modes(let modes):
            SortedSetView(modes) { mode in
                HStack(alignment: .center, spacing: 10) {
                    IconView(mode.icon)
                    Text(mode.rawValue)
                }
            }
        case .platforms(let platforms):
            ForEach(platforms) { platform in
                ForEach(platform.value) { systems in
                    OrientationStack(.vstack) {
                        Text(systems.key.rawValue)
                            .bold()
                        FormatsView(systems.value)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func EditOnView() -> some View {
        switch element {
        case .inputs(let inputs):
            InputsEditOnView(inputs)
        case .modes(let modes):
            ModesEditOnView(modes)
        case .platforms(let platforms):
            PlatformsEditOnView(platforms)
        }
    }
    
    @ViewBuilder
    private func InputsEditOnView(_ inputs: Inputs) -> some View {
        OptionalView(InputEnum.convert(tagType)) { input in
            WrapperView(inputs.get(input).strings) { strings in
                ButtonSection("add \(input.rawValue.lowercased())", action: {
                    self.navigationEnum = .property(builder, input, strings)
                    self.navigation.toggle()
                }, content: {
                    SortedSetView(strings) { string in
                        Text(string).tag(string)
                    }
                    .onDelete(action: { indexSet in
                        indexSet.forEach { index in
                            let value: String = strings[index]
                            let builder: InputBuilder = .init(input, value)
                            let tag: TagBuilder = .input(builder)
                            self.builder.delete(tag)
                        }
                    })
                })
            }
        }
    }
    
    @ViewBuilder
    private func ModesEditOnView(_ modes: Modes) -> some View {
        Section {
            SortedSetView(ModeEnum.self) { mode in
                HStack {
                    IconView(mode.icon)
                    Text(mode.rawValue)
                    Spacer()
                    ModeToggle(.mode(mode))
                }
            }
        }
    }
    
    @ViewBuilder
    private func PlatformsEditOnView(_ platforms: Platforms) -> some View {
        ButtonSection("add \(self.tagType.rawValue)", platforms.unused.isEmpty, action: {
            self.navigationEnum = .platform(builder, nil)
            self.navigation.toggle()
        }, content: {
            SortedSetView(platforms.keys) { systemEnum in
                OptionalView(platforms[systemEnum], content: { systems in
                    SystemsView(systemEnum, systems)
                })
            }
        })
    }
    
    @ViewBuilder
    private func SystemsView(_ systemEnum: SystemEnum, _ systems: Systems) -> some View {
        QuantifiableView(systems.keys) { systemBuilders in
            SortedSetView(systemBuilders) { systemBuilder in
                DisclosureGroup(content: {
                    OptionalView(systems[systemBuilder]) { formats in
                        FormatEnumsView(systemEnum, systemBuilder, formats)
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 10) {
                        Text(systemBuilder.rawValue)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                })
            }
            .onDelete(action: {
                $0.forEach { index in
                    self.builder.delete(systemBuilders[index])
                }
            })
        }
    }
    
    @ViewBuilder
    private func FormatEnumsView(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder, _ formats: Formats) -> some View {
        QuantifiableView(formats.keys) { formatEnums in
            SortedSetView(formatEnums) { formatEnum in
                FormatBuildersView(systemEnum, systemBuilder, formats, formatEnum)
            }
            .onDelete(action: {
                $0.forEach { index in
                    self.builder.delete(systemBuilder, formatEnums[index])
                }
            })
        }
    }
    
    @ViewBuilder
    private func FormatBuildersView(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder, _ formats: Formats, _ formatEnum: FormatEnum) -> some View {
        QuantifiableView(formats.get(formatEnum)) { formatBuilders in
            DisclosureGroup(content: {
                SortedSetView(formatBuilders) { formatBuilder in
                    HStack(spacing: 15) {
                        IconView(.arrow_right, .blue)
                        Text(formatBuilder.rawValue)
                    }
                }
                .onDelete(action: {
                    $0.forEach { index in
                        self.builder.delete(systemBuilder, formatBuilders[index])
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
    
    @ViewBuilder
    private func ModeToggle(_ mode: TagBuilder) -> some View {
        Toggle(String.defaultValue, isOn: .init(get: {
            self.contains(mode)
        }, set: { newValue in
            self.boolean_action(newValue, TRUE: {
                self.builder.add(mode)
            }, FALSE: {
                self.builder.delete(mode)
            })
        }))
    }
    
    @ViewBuilder
    private func FormatsView(_ formats: Formats) -> some View {
        SortedSetView(formats.keys) { key in
            QuantifiableView(formats.get(key)) { value in
                OrientationStack(.hstack) {
                    OrientationStack(.hstack) {
                        IconView(key.icon, 16)
                        Text(value.joined)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
            }
        }
    }
        
}


//
//    @ViewBuilder
//    private func EditOnView() -> some View {
//        case .platforms(let platforms):
//            ButtonSection("add \(self.tagType.rawValue)", platforms.unused.isEmpty, action: {
//                self.navigationEnum = .platform(builder, nil)
//                self.navigation.toggle()
//            }, content: {
//                OptionalArrayView(platforms.keys.sorted()) { systemEnum in
//                    OptionalObjectView(platforms.get(systemEnum)) { systems in
//                        OptionalArrayView(systems.keys.sorted()) { systemBuilders in
//                            ForEach(systemBuilders) { systemBuilder in
//                                DisclosureGroup(content: {
//                                    OptionalObjectView(systems.get(systemBuilder)) { formats in
//                                        OptionalArrayView(formats.keys.sorted()) { formatEnums in
//                                            ForEach(formatEnums) { formatEnum in
//                                                DisclosureGroup(content: {
//                                                    OptionalArrayView(formats.get(formatEnum).sorted()) { formatBuilders in
//                                                        ForEach(formatBuilders) { formatBuilder in
//                                                            HStack(spacing: 15) {
//                                                                IconView(.arrow_right, .blue)
//                                                                Text(formatBuilder.rawValue)
//                                                            }
//                                                        }
//                                                        .onDelete(perform: { indexSet in
//                                                            indexSet.forEach {
//                                                                self.builder.delete(systemBuilder, formatBuilders[$0])
//                                                            }
//                                                        })
//                                                    }
//                                                }, label: {
//                                                    HStack {
//                                                        IconView(formatEnum.icon, .blue)
//                                                        Text(formatEnum.rawValue)
//                                                    }
//                                                })
//                                            }
//                                            .onDelete(perform: { indexSet in
//                                                indexSet.forEach {
//                                                    self.builder.delete(systemBuilder, formatEnums[$0])
//                                                }
//                                            })
//                                        }
//                                    }
//                                }, label: {
//                                    Button(action: {
//                                        self.navigationEnum = .platform(builder, systemBuilder)
//                                        self.navigation.toggle()
//                                    }, label: {
//                                        HStack(alignment: .center, spacing: 10) {
//                                            Text(systemBuilder.rawValue)
//                                                .foregroundColor(.blue)
//                                            Spacer()
//                                        }
//                                    })
//                                })
//                            }
//                            .onDelete(perform: { indexSet in
//                                indexSet.forEach {
//                                    self.builder.delete(systemBuilders[$0])
//                                }
//                            })
//                        }
//                    }
//                }
//            })
//        }
//    }


//////////////////////////////////////
///
///
//
//struct GameView: View {
//
//    private let input: Input
//
//    init(_ model: GameModel) {
//        self.input = .model(model)
//    }
//
//    init(_ status: GameStatusEnum) {
//        self.input = .status(status)
//    }
//
//    var body: some View {
//        switch input {
//        case .model(let model):
//            QueryRelationView(model)
//        case .status(let status):
//            BuilderView(status)
//        }
//    }
//
//    private struct QueryRelationView: View {
//        @Query var relations: [RelationModel]
//
//        let model: GameModel
//
//        init(_ model: GameModel) {
//            let predicate: RelationPredicate = .getByGame(model.uuid)
//            self._relations = .init(filter: predicate)
//            self.model = model
//        }
//
//        var body: some View {
//            QueryPropertyView(relations, model)
//        }
//    }
//
//    private struct QueryPropertyView: View {
//
//        @Query var properties: [PropertyModel]
//
//        let relations: [RelationModel]
//        let model: GameModel
//
//        init(_ relations: [RelationModel], _ model: GameModel) {
//            self.relations = relations
//            let predicate: PropertyPredicate = .getByRelations(relations)
//            self._properties = .init(filter: predicate, sort: .defaultValue)
//            self.model = model
//        }
//
//        var body: some View {
//            BuilderView(model, relations, properties)
//        }
//
//    }
//
//    private struct BuilderView: Gameopticable {
//
//        @Environment(\.dismiss) private var dismiss
//
//        @Environment(\.modelContext) private var modelContext
//
//        @StateObject var builder: GameBuilder
//
//        let isNewGame: Bool
//
//        init(_ model: GameModel, _ relations: [RelationModel], _ properties: [PropertyModel]) {
//            self._builder = .init(wrappedValue: .init(model, relations, properties))
//            self.isNewGame = false
//        }
//
//        init(_ status: GameStatusEnum) {
//            self._builder = .init(wrappedValue: .init(status))
//            self.isNewGame = true
//        }
//
//        var body: some View {
//            Form {
//                GameImageView()
//                BooleanView(isEditing, trueView: EditOnView, falseView: EditOffView)
//                PropertiesView()
//            }
//            .navigationBarBackButtonHidden()
//            .environment(\.editMode, $builder.editMode)
//            .environmentObject(self.builder)
//            .toolbar {
//
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    Button(action: {
//                        boolean_action(isEditing, TRUE: {
//                            // TODO: do the save logic
//                        }, FALSE: self.toggleEditMode)
//                    }, label: {
//                        CustomText(self.topBarTrailingButton)
//                    })
//                    .disabled(builder.isDisabled)
//                })
//
//                ToolbarItem(placement: .topBarLeading, content: {
//                    Button(action: {
//                        boolean_action(isEditing, TRUE: {
//                           boolean_action(isNewGame, TRUE: self.exit, FALSE: {
//                               self.builder.cancel()
//                               self.toggleEditMode()
//                           })
//                        }, FALSE: self.exit)
//                    }, label: {
//                        BooleanView(isEditing, trueView: {
//                            CustomText(.cancel)
//                        }, falseView: {
//                            HStack(alignment: .center, spacing: 5, content: {
//                                IconView(.chevron_left, .blue)
//                                CustomText(.back)
//                            })
//                        })
//                    })
//                })
//
//            }
//        }
//
//        private func exit() -> Void {
//            self.dismiss()
//        }
//
//        @ViewBuilder
//        private func EditOnView() -> some View {
//            Section {
//                CustomTextField(.title, $builder.title)
//            }
//            Section {
//                CustomDatePicker(.release_date, $builder.release)
//            }
//
//            Section {
//                Picker(ConstantEnum.property.rawValue, selection: $builder.tagType) {
//                    ForEach(TagType.cases) { tag in
//                        Text(tag.rawValue)
//                            .tag(tag)
//                    }
//                }
//                .pickerStyle(.menu)
//            }
//
//        }
//
//        @ViewBuilder
//        private func EditOffView() -> some View {
//            Section {
//                FormattedView(.title, self.title)
//                FormattedView(.release_date, self.release.long)
//            }
//        }
//
//    }
//
//    private enum Input {
//        case model(GameModel)
//        case status(GameStatusEnum)
//    }
//
//}
//

//@ViewBuilder
//private func FormatsView(_ formats: Formats) -> some View {
//    OptionalArrayView(formats.keys.sorted()) { keys in
//        OrientationStack(.hstack) {
//            ForEach(keys) { key in
//                OptionalArrayView(formats.get(key).sorted()) { builders in
//                    OrientationStack(.hstack) {
//                        IconView(key.icon, 16)
//                        Text(builders.joined)
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                            .italic()
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    //        OptionalArrayView(group.keys) { keys in
//    //            OrientationStack(.hstack) {
//    //                ForEach(keys) { key in
//    //                    OptionalArrayView(group.filter(key)) { formats in
//    //                        OrientationStack(.hstack) {
//    //                            IconView(key.icon, 16)
//    //                            Text(formats.joined)
//    //                                .font(.system(size: 14))
//    //                                .foregroundColor(.gray)
//    //                                .italic()
//    //                        }
//    //                    }
//    //                }
//    //            }
//    //        }
//}
//
////    @ViewBuilder
////    private func FormatsView(_ group: [FormatBuilder]) -> some View {
////        OptionalArrayView(group.keys) { keys in
////            OrientationStack(.hstack) {
////                ForEach(keys) { key in
////                    OptionalArrayView(group.filter(key)) { formats in
////                        OrientationStack(.hstack) {
////                            IconView(key.icon, 16)
////                            Text(formats.joined)
////                                .font(.system(size: 14))
////                                .foregroundColor(.gray)
////                                .italic()
////                        }
////                    }
////                }
////            }
////        }
////    }



//                            DisclosureGroup(content: {
//
//
//                                OptionalObjectView(systems.get(systemBuilder)) { formats in
//
////                                    OptionalArrayView(formats.keys.sorted()) { formatEnums in
////
////                                        ForEach(formatEnums) { formatEnum in
////
////                                        }
////
//////                                        OptionalObjectView(formats.get(format)) { formatBuilder in
//////
//////
//////
//////                                        }
////
////                                    }
////                                    .onDelete(perform: { indexSet in
////                                        indexSet.forEach {
////                                            self.builder.delete(systemBuilder, formatEnums[$0])
////                                        }
////                                    })
//
//                                }
//
//
//                            }, label: {
//                                Button(action: {
//                                    self.navigationEnum = .platform(builder, systemBuilder)
//                                    self.navigation.toggle()
//                                }, label: {
//                                    HStack(alignment: .center, spacing: 10) {
//                                        Text(systemBuilder.rawValue)
//                                            .foregroundColor(.blue)
//                                        Spacer()
//                                    }
//                                })
//                            })


//                OptionalArrayView(platforms.systemKeys) { systems in
//                    ForEach(systems) { system in
//                        OptionalArrayView(FormatEnum.cases) { formatEnums in
//                            DisclosureGroup(content: {
//                                ForEach(formatEnums) { formatEnum in
//                                    OptionalObjectView(platforms.get(system)) { formats in
//                                        DisclosureGroup(content: {
//                                                ForEach(formats) { format in
//                                                    HStack(spacing: 15) {
//                                                        IconView(.arrow_right, .blue)
//                                                        Text(format.rawValue)
//                                                    }
//                                                }
//                                                .onDelete(perform: { indexSet in
//                                                    indexSet.forEach {
//                                                        self.builder.delete(system, formats[$0])
//                                                    }
//                                                })
//                                        }, label: {
//                                            HStack {
//                                                IconView(formatEnum.icon, .blue)
//                                                Text(formatEnum.rawValue)
//                                            }
//                                        })
//                                    }
//                                }
//                                                    .onDelete(perform: { indexSet in
//                                                        indexSet.forEach {
//                                                            self.builder.delete(system, formatEnums[$0])
//                                                        }
//                                                    })
//                            }, label: {
//                                Button(action: {
//                                    self.navigationEnum = .platform(builder, system)
//                                    self.navigation.toggle()
//                                }, label: {
//                                    HStack(alignment: .center, spacing: 10) {
//                                        Text(system.rawValue)
//                                            .foregroundColor(.blue)
//                                        Spacer()
//                                    }
//                                })
//                            })
//                        }
//                    }
//                                    .onDelete(perform: { indexSet in
//                                        indexSet.forEach {
//                                            self.builder.delete(systems[$0])
//                                        }
//                                    })
//                }
