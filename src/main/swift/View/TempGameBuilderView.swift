//
//  TempGameBuilderView.swift
//  autosave
//
//  Created by Asia Serrano on 8/24/25.
//

import SwiftUI

struct TempGameBuilderView: TagsObservableProtocol {
    
    @StateObject fileprivate var observable: TagsObservable = .random
    
    var body: some View {
        NavigationStack {
            Form {
                PropertiesView()
            }
            .environment(\.editMode, $observable.editMode)
            .environmentObject(self.observable)
            .toolbar {
                
                ToolbarItem {
                    Button(self.isEditing ? "Done": "Edit") {
                        let edit: EditMode = self.observable.editMode
                        self.observable.editMode = edit.toggle
                    }
                }
                
            }
        }
    }
    
}

fileprivate struct PropertiesView: TagsObservableProtocol {
    
    @EnvironmentObject public var observable: TagsObservable
    
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

fileprivate struct TagsElementView: TagsObservableProtocol {
    
    typealias Element = TagsElement
            
    @State var navigation: Bool = false
    @State var navigationEnum: NavigationEnum? = .none
    
    @EnvironmentObject public var observable: TagsObservable
    
    let element: Element
    
    init(_ element: Element) {
        self.element = element
    }
    
    var body: some View {
        BooleanView(isEditing, trueView: EditOnView, falseView: EditOffView)
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
        
        Section {
            Picker(ConstantEnum.property.rawValue, selection: $observable.tagType) {
                ForEach(TagType.cases) { tag in
                    Text(tag.rawValue)
                        .tag(tag)
                }
            }
            .pickerStyle(.menu)
        }
        
        switch element {
        case .inputs(let inputs):
            InputsEditOnView(inputs)
        case .modes(let modes):
            ModesEditOnView(modes)
        case .platforms(let platforms):
            PlatformsEditOnView(platforms)
        }
        
        Section("Master") {
            SortedSetView(self.builders, content: FormattedView)
        }
    }
    
    @ViewBuilder
    private func InputsEditOnView(_ inputs: Inputs) -> some View {
        OptionalView(InputEnum.convert(tagType)) { input in
            QuantifiableView(inputs[input]) { (strings: StringBuilders) in
                ButtonSection("add \(input.rawValue.lowercased())", action: {
//                    self.navigationEnum = .property(builder, input, strings)
//                    self.navigation.toggle()
                }, content: {
                    SortedSetView(strings) { string in
                        Text(string.rawValue).tag(string)
                    }
                    .onDelete(action: { indexSet in
                        indexSet.forEach { index in
                            let value: StringBuilder = strings[index]
                            let builder: InputBuilder = .init(input, value)
                            let tag: TagBuilder = .input(builder)
                            self.observable.delete(tag)
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
//            self.navigationEnum = .platform(builder, nil)
//            self.navigation.toggle()
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
                    self.observable.delete(systemBuilders[index])
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
                    self.observable.delete(systemBuilder, formatEnums[index])
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
                        self.observable.delete(systemBuilder, formatBuilders[index])
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
                self.observable.add(mode)
            }, FALSE: {
                self.observable.delete(mode)
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

fileprivate class TagsObservable: ObservableObject {
    
    public static var random: TagsObservable {
       .init(.random)
    }
    
    @Published var tags: Tags
    @Published var editMode: EditMode
    @Published var tagType: TagType
    
    init(_ t: Tags) {
        self.tags = t
        self.tagType = .mode
        self.editMode = .active
    }

//    @MainActor
    func delete(_ builder: TagBuilder) {
        self.tags -= builder
    }
    
    var builders: TagBuilders { self.tags.builders }
    
    func add(_ i: InputBuilder) -> Void {
        let builder: TagBuilder = .input(i)
        self.add(builder)
    }
    
    func delete(_ i: InputBuilder) -> Void {
        self.tags -= .input(i)
    }
    
    func add(_ builder: TagBuilder) -> Void {
        self.tags += builder
    }
    
    func delete(_ input: InputEnum) -> Void {
        self.tags -= input
    }
    
    func delete(_ system: SystemBuilder) -> Void {
        self.tags -= system
    }
    
    func delete(_ system: SystemBuilder, _ format: FormatEnum) -> Void {
        self.tags -= (system, format)
    }
    
    func delete(_ system: SystemBuilder, _ format: FormatBuilder) -> Void {
        let builder: TagBuilder = .platform(system, format)
        self.delete(builder)
    }
    
    func set(_ member: Platforms.Member) -> Void {
        self.tags --> (member.key, member.value)
    }
    
}

fileprivate protocol TagsObservableProtocol: View {
    var observable: TagsObservable { get }
}

extension TagsObservableProtocol {
    
    var tags: Tags { self.observable.tags }
    var builders: TagBuilders { self.observable.builders }
    var inputs: Inputs { self.tags.inputs }
    var isEditing: Bool {  self.observable.editMode == .active }
    var tagType: TagType { self.observable.tagType }
    
    func contains(_ tag: TagBuilder) -> Bool {
        self.builders.contains(tag)
    }
    
}


#Preview {
    TempGameBuilderView()
}
