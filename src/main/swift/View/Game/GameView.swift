//
//  GameView.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
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
                TagsElementView(.build(tags, tagType))
            }, falseView: {
                ForEach(TagCategory.cases) { category in
                    QuantifiableView(.build(tags, category)) { element in
                        SectionWrapper(category) {
                            TagsElementView(element)
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

fileprivate struct TagsElementView: Gameopticable {
    
    typealias Element = TagsElement
        
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
                
                //TODO: Fix
                EmptyView()
//                OptionalView(self.navigationEnum) { nav in
//                    switch nav {
//                    case .property(let gameBuilder, let inputEnum, let array):
//                        AddPropertyView(gameBuilder, inputEnum, array)
//                    case .platform(let gameBuilder, let systemBuilder):
//                        AddPlatformView(gameBuilder, systemBuilder)
//                    }
//                }
            })
    }
    
    @ViewBuilder
    private func EditOffView() -> some View {
        switch element {
        case .inputs(let inputs):
            SortedSetView(inputs.keys) { key in
                QuantifiableView(inputs[key].joined) { value in
                    FormattedView(key.rawValue.pluralize(), value)
                }
            }
        case .modes(let modes):
            SortedSetView(modes.elements) { mode in
                HStack(alignment: .center, spacing: 10) {
                    IconView(mode.icon)
                    Text(mode.rawValue)
                }
            }
        case .platforms(let platforms):
            SortedSetView(platforms.keys) { systemEnum in
                QuantifiableView(platforms[systemEnum]) { (systems: Systems) in
                    SortedSetView(systems.keys) { systemBuilder in
                        OrientationStack(.vstack) {
                            Text(systemBuilder.rawValue)
                                .bold()
                            FormatsView(systems[systemBuilder])
                        }
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
            QuantifiableView(inputs[input]) { (strings: StringBuilders) in
                ButtonSection("add \(input.rawValue.lowercased())", action: {
                    self.navigationEnum = .property(builder, input, strings)
                    self.navigation.toggle()
                }, content: {
                    SortedSetView(strings) { string in
                        Text(string.rawValue).tag(string)
                    }
                    .onDelete(action: { indexSet in
                        indexSet.forEach { index in
                            let value: StringBuilder = strings[index]
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
        WrapperView(platforms.values.flatMap { $0.value.keys }) { used in
            ButtonSection("add \(self.tagType.rawValue)", (SystemBuilder.cases - used).isEmpty, action: {
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
        QuantifiableView(formats[formatEnum]) { formatBuilders in
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
            QuantifiableView(formats[key]) { value in
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

fileprivate enum TagsElement: Quantifiable {
    
    public static func build(_ tags: Tags, _ key: TagType) -> Self {
        switch key {
        case .input:
            return .inputs(tags.inputs)
        case .mode:
            return .modes(tags.modes)
        case .platform:
            return .platforms(tags.platforms)
        }
    }
    
    public static func build(_ tags: Tags, _ key: TagCategory) -> Self {
        switch key {
        case .input:
            return .inputs(tags.inputs)
        case .mode:
            return .modes(tags.modes)
        case .platform:
            return .platforms(tags.platforms)
        }
    }
    
    case inputs(Inputs)
    case modes(Modes)
    case platforms(Platforms)
    
    public var quantity: Int {
        switch self {
        case .inputs(let i):
            return i.quantity
        case .modes(let m):
            return m.quantity
        case .platforms(let p):
            return p.quantity
        }
    }
}
