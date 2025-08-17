//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

fileprivate class MyObservableClass: ObservableObject {
    
    @Published var group: TagGroup = .defaultValue
    
}

struct TestingView: View {
    
    @StateObject fileprivate var observable: MyObservableClass = .init()
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(TagGroup.K.cases) { key in
                    switch observable.group.get(key) {
                    case .inputs(let inputs):
                        Section {
                            ForEach(inputs) { e in
                                FormattedView(e.key.rawValue, e.value.joined)
                            }
                        }
                    case .modes(let modes):
                        Section {
                            SortedSetView(modes) { mode in
                                FormattedView("Mode", mode.rawValue)
                            }
                        }
                    case .platforms(let platforms):
                        Section {
                            ForEach(platforms, content: PlatformsView)
                        }
                    }
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        observable.group += random//get(.random)
                    }, label: {
                        Text("Add")
                    })
                })
            }
        }
    }
    
    private var random: TagGroup.Element {
        switch observable.group.get(.random) {
        case .inputs(let inputs):
            return .inputs(inputs + (.random, .random))
        case .modes(let modes):
            return .modes(modes + .random)
        case .platforms(let platforms):
            let system: SystemBuilder = .random
            return .platforms(platforms + (system, .random(system)))
        }
    }
    
    @ViewBuilder
    func PlatformsView(_ element: Platforms.Element) -> some View {
        ForEach(element.value) { systems in
            FormattedView(systems.key.rawValue, systems.value.flatMap { $0.value.map { $0.rawValue}}.joined(separator: ", "))
        }
    }
    
}

//struct TestingView: View {
//    
//    @StateObject fileprivate var observable: MyObservableClass = .init()
//    
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                OptionalView(self.observable.group.get(.inputs)) { element in
//                    switch element {
//                    case .inputs(let i):
//                        ForEach(i) { e in
//                            FormattedView(e.key.rawValue, e.value.joined)
//                        }
//                    default:
//                        EmptyView()
//                    }
//                }
//            }
//            .toolbar {
//                
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    Button(action: {
//                        if let element: TagGroup.Element = self.observable.group[.inputs] {
//                            switch element {
//                            case .inputs(var i):
//                                let key: InputEnum = .random
//                                i[key] = i.get(key) + .string(.random)
//                                
//                                var group: TagGroup = self.observable.group
//                                group[.inputs] = .inputs(i)
//                                self.observable.group = group
//                            default:
//                                break
//                            }
//                        }
//                    }, label: {
//                        Text("Add")
//                    })
//                })
//            }
//        }
//    }
//    
//}

#Preview {
    TestingView()
}

//// TODO: FIX THIS AND ADD IT TO GAMEVIEW
//struct TestingView: View {
//    
//    @State var platforms: Platforms
//    
//    init() {
//        self._platforms = .init(wrappedValue: .random)
//    }
//    
//    var body: some View {
//        
//        NavigationStack {
//            Form {
//                SortedMapView(platforms) { systemEnum, systems in
//                    QuantifiableView(systems.keys) { keys in
//                        SortedSetView(keys) { system in
//                            QuantifiableView(systems.get(system)) { formats in
//                                DisclosureGroup(content: {
//                                    QuantifiableView(formats.keys) { formatEnums in
//                                        SortedSetView(formatEnums) { formatEnum in
//                                            QuantifiableView(formats.get(formatEnum)) { formatBuilders in
//                                                
//                                                DisclosureGroup(content: {
//                                                    SortedSetView(formatBuilders) { formatBuilder in
//                                                        HStack(spacing: 15) {
//                                                            IconView(.arrow_right, .blue)
//                                                            Text(formatBuilder.rawValue)
//                                                        }
//                                                    }
//                                                    .onDelete(action: {
//                                                        $0.forEach { index in
//                                                            delete(system, formats - formatBuilders[index])
//                                                        }
//                                                    })
//                                                }, label: {
//                                                    HStack {
//                                                        IconView(formatEnum.icon, .blue)
//                                                        Text(formatEnum.rawValue)
//                                                    }
//                                                })
//                                    
//                                            }
//                                        }
//                                        .onDelete { indexSet in
//                                            indexSet.forEach { index in
//                                                delete(system, formats - formatEnums[index])
//                                            }
//                                        }
//                                    }
//                                }, label: {
//                                    Button(action: {
//                                        //                self.navigationEnum = .platform(builder, systemBuilder)
//                                        //                self.navigation.toggle()
//                                    }, label: {
//                                        HStack(alignment: .center, spacing: 10) {
//                                            Text(system.rawValue)
//                                                .foregroundColor(.blue)
//                                            Spacer()
//                                        }
//                                    })
//                                })
//                            }
//                        }
//                        .onDelete { indexSet in
//                            indexSet.forEach {
//                                self.set(systems - keys[$0], systemEnum)
//                            }
//                        }
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    Button(action: {
//                        self.platforms += .random
//                    }, label: {
//                        Text("Add")
//                    })
//                })
//            }
//        }
//    }
//    
//    private func delete(_ system: SystemBuilder, _ formats: Formats) -> Void {
//        let key: SystemEnum = system.type
//        var systems: Systems = self.platforms.get(key)
//        systems[system] = formats
//        self.set(systems, key)
//    }
//    
//    private func set(_ systems: Systems, _ systemEnum: SystemEnum) -> Void {
//        self.platforms[systemEnum] = systems
//    }
//    
////    @ViewBuilder
////    private func FormatsView(_ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders, _ action: @escaping DeleteAction) -> some View {
////        DisclosureGroup(content: {
////            SortedSetView(formatBuilders) { formatBuilder in
////                HStack(spacing: 15) {
////                    IconView(.arrow_right, .blue)
////                    Text(formatBuilder.rawValue)
////                }
////            }
////            .onDelete(action: action)
////        }, label: {
////            HStack {
////                IconView(formatEnum.icon, .blue)
////                Text(formatEnum.rawValue)
////            }
////        })
////    }
//    
////    @ViewBuilder
////    private func FormatsView(_ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders, _ action: @escaping DeleteAction) -> some View {
////        DisclosureGroup(content: {
////            SortedSetView(formatBuilders) { formatBuilder in
////                HStack(spacing: 15) {
////                    IconView(.arrow_right, .blue)
////                    Text(formatBuilder.rawValue)
////                }
////            }
////            .onDelete(action: action)
////        }, label: {
////            HStack {
////                IconView(formatEnum.icon, .blue)
////                Text(formatEnum.rawValue)
////            }
////        })
////    }
//
//    
////    private enum ActionEnum {
////        case
////    }
//    
////    private func systemsBinding(_ system: SystemEnum, _ systems: Systems) -> Binding<Systems> {
////        .init(get: {
////            systems
////        }, set: { newValue in
////            self.platforms[system] = newValue
////        })
////    }
//    
//    typealias DeleteAction = (IndexSet) -> Void
//    
////    @ViewBuilder
////    private func SystemsView(_ element: Platforms.Element) -> some View {
////        WrapperView(element.value) { systems in
////            QuantifiableView(systems.keys) { keys in
////                SortedSetView(keys) { system in
////                    QuantifiableView(systems.get(system)) { formats in
////                        FormatsView(system, formats)
////                    }
////                }
////                .onDelete { indexSet in
////                    indexSet.forEach {
////                        self.platforms[element.key] = systems - keys[$0]
////                    }
////                }
////            }
////            
////        }
////    }
//    
////    @ViewBuilder
////    private func FormatsView(_ system: SystemBuilder, _ formats: Formats) -> some View {
////        WrapperView(system.type) { systemEnum in
////            DisclosureGroup(content: {
////                QuantifiableView(formats.keys) { formatEnums in
////                    SortedSetView(formatEnums) { formatEnum in
////                        QuantifiableView(formats.get(formatEnum)) { formatBuilders in
////                            FormatsView(formatEnum, formatBuilders) { indexSet in
////                                indexSet.forEach { index in
////                                    delete(system, formats - formatBuilders[index])
////                                }
//////                                indexSet.forEach { index in
//////                                    var systems: Systems = self.platforms.get(systemEnum)
//////                                    systems[system] = formats - formatBuilders[index]
//////                                    self.platforms[systemEnum] = systems
//////                                }
////                            }
////                        }
////                    }
////                    .onDelete { indexSet in
////                        indexSet.forEach { index in
////                            delete(system, formats - formatEnums[index])
//////                            var systems: Systems = self.platforms.get(systemEnum)
//////                            systems[system] = formats - formatEnums[index]
//////                            self.platforms[systemEnum] = systems
////                        }
////                    }
////                }
////            }, label: {
////                Button(action: {
////                    //                self.navigationEnum = .platform(builder, systemBuilder)
////                    //                self.navigation.toggle()
////                }, label: {
////                    HStack(alignment: .center, spacing: 10) {
////                        Text(system.rawValue)
////                            .foregroundColor(.blue)
////                        Spacer()
////                    }
////                })
////            })
////        }
////    }
//    
//}
//
////fileprivate struct SystemsView: View {
////    
////    @Binding var systems: Systems
////    
////    init(_ systems: Binding<Systems>) {
////        self._systems = systems
////    }
////    
////    var body: some View {
////        QuantifiableView(systems.keys) { keys in
////            SortedSetView(systems.keys) { key in
////                QuantifiableView(systems.get(key)) { value in
////                    FormatsView(key, value)
////                }
////            }
////            .onDelete { indexSet in
////                indexSet.forEach { self.systems -= keys[$0] }
////            }
////        }
////    }
////    
//////    private func formatsBinding(_ system: SystemBuilder, _ formats: Formats) -> Binding<Formats> {
//////        .init(get: {
//////            formats
//////        }, set: { newValue in
//////            self.systems[system] = newValue
//////        })
//////    }
////    
////    
////    
////    @ViewBuilder
////    private func FormatsView(_ system: SystemBuilder, _ formats: Formats) -> some View {
////        DisclosureGroup(content: {
////            QuantifiableView(formats.keys) { formatEnums in
////                SortedSetView(formatEnums) { formatEnum in
////                    QuantifiableView(formats.get(formatEnum)) { formatBuilders in
////                        FormatsView(formatEnum, formatBuilders) { indexSet in
////                            indexSet.forEach { self.systems[system] = formats - formatBuilders[$0] }
////                        }
////                    }
////                }
////                .onDelete { indexSet in
////                    indexSet.forEach { self.systems[system] = formats - formatEnums[$0] }
////                }
////            }
////        }, label: {
////            Button(action: {
////                //                self.navigationEnum = .platform(builder, systemBuilder)
////                //                self.navigation.toggle()
////            }, label: {
////                HStack(alignment: .center, spacing: 10) {
////                    Text(system.rawValue)
////                        .foregroundColor(.blue)
////                    Spacer()
////                }
////            })
////        })
////    }
////    
////    @ViewBuilder
////    private func FormatsView(_ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders, _ action: @escaping (IndexSet) -> Void) -> some View {
////        DisclosureGroup(content: {
////            SortedSetView(formatBuilders) { formatBuilder in
////                HStack(spacing: 15) {
////                    IconView(.arrow_right, .blue)
////                    Text(formatBuilder.rawValue)
////                }
////            }
////            .onDelete(action: action)
////        }, label: {
////            HStack {
////                IconView(formatEnum.icon, .blue)
////                Text(formatEnum.rawValue)
////            }
////        })
////    }
////    
////}
////
////fileprivate struct FormatsView: View {
////    
////    @Binding var formats: Formats
////    let system: SystemBuilder
////    
////    init(_ system: SystemBuilder, _ formats: Binding<Formats>) {
////        self._formats = formats
////        self.system = system
////    }
////    
////    var body: some View {
////        DisclosureGroup(content: {
////            QuantifiableView(formats.keys) { formatEnums in
////                SortedSetView(formatEnums) { formatEnum in
////                    QuantifiableView(formats.get(formatEnum)) { formatBuilders in
////                        FormatView(formatEnum, formatBuilders)
////                    }
////                }
////                .onDelete { indexSet in
////                    indexSet.forEach {
////                        self.formats -= formatEnums[$0]
////                    }
////                }
////            }
////        }, label: {
////            Button(action: {
////                //                self.navigationEnum = .platform(builder, systemBuilder)
////                //                self.navigation.toggle()
////            }, label: {
////                HStack(alignment: .center, spacing: 10) {
////                    Text(system.rawValue)
////                        .foregroundColor(.blue)
////                    Spacer()
////                }
////            })
////        })
////    }
////    
////    @ViewBuilder
////    private func FormatView() -> some View {
////        DisclosureGroup(content: {
////            QuantifiableView(formats.keys) { formatEnums in
////                SortedSetView(formatEnums) { formatEnum in
////                    QuantifiableView(formats.get(formatEnum)) { formatBuilders in
////                        FormatView(formatEnum, formatBuilders)
////                    }
////                }
////                .onDelete { indexSet in
////                    indexSet.forEach {
////                        self.formats -= formatEnums[$0]
////                    }
////                }
////            }
////        }, label: {
////            Button(action: {
////                //                self.navigationEnum = .platform(builder, systemBuilder)
////                //                self.navigation.toggle()
////            }, label: {
////                HStack(alignment: .center, spacing: 10) {
////                    Text(system.rawValue)
////                        .foregroundColor(.blue)
////                    Spacer()
////                }
////            })
////        })
////    }
////    
////    @ViewBuilder
////    private func FormatView( _ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders) -> some View {
////        DisclosureGroup(content: {
////            SortedSetView(formatBuilders) { formatBuilder in
////                HStack(spacing: 15) {
////                    IconView(.arrow_right, .blue)
////                    Text(formatBuilder.rawValue)
////                }
////            }
////            .onDelete{ indexSet in
////                indexSet.forEach {
////                    self.formats -= formatBuilders[$0]
////                }
////            }
////        }, label: {
////            HStack {
////                IconView(formatEnum.icon, .blue)
////                Text(formatEnum.rawValue)
////            }
////        })
////    }
////    
////}
//
//
//
//
////
//
//
//
//
//
//
//
///*
//
// struct TestingView: View {
//     
//     @State var platforms: Platforms
//     
//     init() {
//         self._platforms = .init(wrappedValue: .random)
//     }
//     
//     var body: some View {
//         
//         NavigationStack {
//             Form {
//                 SortedMapView(platforms) { key, value in
//                     Section(key.rawValue) {
//                         SystemsView(systemsBinding(key, value))
//                     }
//                 }
//             }
//             .toolbar {
//                 ToolbarItem(placement: .topBarTrailing, content: {
//                     Button(action: {
//                         self.platforms += .random
//                     }, label: {
//                         Text("Add")
//                     })
//                 })
//             }
//         }
//     }
//     
//     private func systemsBinding(_ system: SystemEnum, _ systems: Systems) -> Binding<Systems> {
//         .init(get: {
//             systems
//         }, set: { newValue in
//             self.platforms[system] = newValue
//         })
//     }
//     
// }
// 
//fileprivate struct SystemsView: View {
//    
//    @Binding var systems: Systems
//    
//    init(_ systems: Binding<Systems>) {
//        self._systems = systems
//    }
//    
//    var body: some View {
//        QuantifiableView(systems.keys) { keys in
//            SortedSetView(systems.keys) { key in
//                QuantifiableView(systems.get(key)) { value in
//                    FormatsView(key, formatsBinding(key, value))
//                }
//            }
//            .onDelete { indexSet in
//                indexSet.forEach { self.systems -= keys[$0] }
//            }
//        }
//    }
//    
//    private func formatsBinding(_ system: SystemBuilder, _ formats: Formats) -> Binding<Formats> {
//        .init(get: {
//            formats
//        }, set: { newValue in
//            self.systems[system] = newValue
//        })
//    }
//    
//}
//
//fileprivate struct FormatsView: View {
//    
//    @Binding var formats: Formats
//    let system: SystemBuilder
//    
//    init(_ system: SystemBuilder, _ formats: Binding<Formats>) {
//        self._formats = formats
//        self.system = system
//    }
//    
//    var body: some View {
//        DisclosureGroup(content: {
//            QuantifiableView(formats.keys) { formatEnums in
//                SortedSetView(formatEnums) { formatEnum in
//                    QuantifiableView(formats.get(formatEnum)) { formatBuilders in
//                        FormatView(formatEnum, formatBuilders)
//                    }
//                }
//                .onDelete { indexSet in
//                    indexSet.forEach {
//                        self.formats -= formatEnums[$0]
//                    }
//                }
//            }
//        }, label: {
//            Button(action: {
//                //                self.navigationEnum = .platform(builder, systemBuilder)
//                //                self.navigation.toggle()
//            }, label: {
//                HStack(alignment: .center, spacing: 10) {
//                    Text(system.rawValue)
//                        .foregroundColor(.blue)
//                    Spacer()
//                }
//            })
//        })
//    }
//    
//    @ViewBuilder
//    private func FormatView( _ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders) -> some View {
//        DisclosureGroup(content: {
//            SortedSetView(formatBuilders) { formatBuilder in
//                HStack(spacing: 15) {
//                    IconView(.arrow_right, .blue)
//                    Text(formatBuilder.rawValue)
//                }
//            }
//            .onDelete{ indexSet in
//                indexSet.forEach {
//                    self.formats -= formatBuilders[$0]
//                }
//            }
//        }, label: {
//            HStack {
//                IconView(formatEnum.icon, .blue)
//                Text(formatEnum.rawValue)
//            }
//        })
//    }
//    
//}
//
//*/
//
//
//
////    @ViewBuilder
////    private func SystemView(_ systems: Systems) -> some View {
////        WrapperView(systems.keys) { keys in
////            SortedSetView(systems.keys) { key in
////                QuantifiableView(systems.get(key)) { value in
////                    FormatView(key, value)
////                }
////            }
//////            .onDelete { indexSet in
//////                indexSet.forEach { self.platforms -= keys[$0] }
//////            }
////        }
////    }
//
////    @ViewBuilder
////    private func FormatView(_ systemBuilder: SystemBuilder, _ formats: Formats) -> some View {
////        DisclosureGroup(content: {
////            QuantifiableView(formats.keys) { formatEnums in
////                SortedSetView(formatEnums) { formatEnum in
////                    QuantifiableView(formats.get(formatEnum)) { formatBuilders in
////                        FormatView(systemBuilder, formats, formatEnum, formatBuilders)
////                    }
////                }
////                .onDelete { indexSet in
////                    indexSet.forEach {
////                        self.platforms -= (systemBuilder, formatEnums[$0])
//////                        self.systems[systemBuilder] = formats - formatEnums[$0]
//////                            self.formats = self.formats - formatEnums[$0]
////                    }
////                }
////            }
////        }, label: {
////            Button(action: {
////                //                self.navigationEnum = .platform(builder, systemBuilder)
////                //                self.navigation.toggle()
////            }, label: {
////                HStack(alignment: .center, spacing: 10) {
////                    Text(systemBuilder.rawValue)
////                        .foregroundColor(.blue)
////                    Spacer()
////                }
////            })
////        })
////    }
//
////    @ViewBuilder
////    private func FormatView(_ systemBuilder: SystemBuilder, _ formats: Formats, _ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders) -> some View {
////        DisclosureGroup(content: {
////            SortedSetView(formatBuilders) { formatBuilder in
////                HStack(spacing: 15) {
////                    IconView(.arrow_right, .blue)
////                    Text(formatBuilder.rawValue)
////                }
////            }
////            .onDelete{ indexSet in
////                indexSet.forEach {
////                    self.platforms -= .init(systemBuilder, formatBuilders[$0])
////                }
////            }
////        }, label: {
////            HStack {
////                IconView(formatEnum.icon, .blue)
////                Text(formatEnum.rawValue)
////            }
////        })
////    }
//
//
//
////struct TestingView: View {
////    
////    @State var sortedSet: SortedSet<TagBuilder> = .init()
////
////    var body: some View {
////        NavigationStack {
////            Form {
////                
////                ForEach(self.sortedSet) {
////                    BuilderView($0)
////                }
////                
////            }
////            .toolbar {
////                
////                ToolbarItem(placement: .topBarTrailing, content: {
////                    Button("Add") {
////                        let a: TagBuilder = create()
////                        let b: TagBuilder = create()
////                        print("____________________")
////                        let new: SortedSet<TagBuilder> = .init(a, b)
////                        self.sortedSet += new
////                    }
////                })
////             
////            }
////        }
////    }
////    
////    func create() -> TagBuilder {
////        let b: TagBuilder = .random
////        switch b {
////        case .input(let inputBuilder):
////            print(inputBuilder.type.rawValue + " " + inputBuilder.stringBuilder.trim)
////        case .mode(let modeEnum):
////            print("Mode" + " " + modeEnum.rawValue)
////        case .platform(let platformBuilder):
////            print(platformBuilder.system.rawValue + " " + platformBuilder.format.rawValue)
////        }
////        return b
////    }
////    
////    @ViewBuilder
////    func BuilderView(_ builder: TagBuilder) -> some View {
////        switch builder {
////        case .input(let inputBuilder):
////            FormattedView(inputBuilder.type.rawValue, inputBuilder.stringBuilder.trim)
////        case .mode(let modeEnum):
////            FormattedView("Mode", modeEnum.rawValue)
////        case .platform(let platformBuilder):
////            FormattedView(platformBuilder.system.rawValue, platformBuilder.format.rawValue)
////        }
////    }
//////    
//////    func isNotValid(_ container: TagContainer) -> Bool {
//////        let master: Int = container.getCount(.master)
//////        let inputs: Int = container.getCount(.inputs)
//////        let modes: Int = container.getCount(.modes)
//////        let platforms: Int = container.getCount(.platforms)
//////        let maps: Int = inputs + modes + platforms
//////        let result: Bool = master != maps
//////        
//////        if result {
//////            print("master: \(master)")
//////            print("inputs: \(inputs)")
//////            print("modes: \(modes)")
//////            print("platforms: \(platforms)")
//////            print("maps: \(maps)")
//////        }
//////        return result
//////    }
////    
//////    @StateObject var gameBuilder: GameBuilder = .init(.library)
//////    
//////    var body: some View {
//////        NavigationStack {
//////            Form {
//////                
//////                Text("count: \(self.gameBuilder.count.description)")
//////                
//////            }
//////        
//////            .toolbar {
//////                
//////                ToolbarItem(placement: .topBarTrailing, content: {
//////                    Button("Add") {
//////                        self.gameBuilder.add(.random)
//////                    }
//////                })
//////                
//////            }
//////        }
//////    }
////    
//////    func modeBinding(_ mode: ModeEnum) -> Binding<Bool> {
//////        let builder: TagBuilder = .mode(mode)
//////        return .init(get: {
//////            self.tags.contains(builder)
//////        }, set: { newValue in
//////            if newValue {
//////                self.tags.add(builder)
//////            } else {
//////                self.tags.delete(builder)
//////            }
//////        })
//////    }
////    
////}
//
//#Preview {
//    
//    var array: [TagContainer] {
//        var new: [TagContainer] = []
//        while new.count < 20 {
//            new.append(.random)
//        }
//        return new
//    }
//    
//    TestingView()
//}
