////
////  AddPlatformView.swift
////  autosave
////
////  Created by Asia Serrano on 7/14/25.
////
//
import SwiftUI
import SwiftData

//struct AddPlatformView: View {
//    
//    init(_ builder: GameBuilder, _ system: SystemBuilder? = nil) {
//
//    }
//    
//    var body: some View {
//        Text("self.TBD")
//    }
//    
//    
//}



struct AddPlatformView: AddPlatformProtocol {

    @Environment(\.dismiss) var dismiss

    @ObservedObject var builder: GameBuilder
    
    @StateObject fileprivate var object: AddPlatform
        
    init(_ builder: GameBuilder, _ system: SystemBuilder? = nil) {
        self._object = .init(wrappedValue: .init(builder, system))
        self.builder = builder
    }
    
    var body: some View {
        
        Form {
            
            Text("object count: \(self.object.count.description)")
            
            BooleanView(self.isNavigationLinkDisabled, trueView: PlatformLabel, falseView: FalseView)
            
            OptionalView(self.system) { systemBuilder in
                DigitalView(systemBuilder)
                PhysicalView(systemBuilder)
            }
            
        }
        .navigationTitle(self.navigationTitle)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if let element: Systems.Element = self.element {
                        print("setting")
                        self.builder.set(element)
                        self.dismiss()
                    } else {
                        print("not setting")
                    }
                }, label: {
                    CustomText(.done)
                })
                .disabled(self.isDoneDisabled)
            }
            
        }
    
    }
    
    @ViewBuilder
    private func FalseView() -> some View {
        NavigationLink(destination: {
            SelectPlatformView()
                .environmentObject(self.builder)
                .environmentObject(self.object)
        }, label: PlatformLabel)
    }
    
    @ViewBuilder
    private func DigitalView(_ systemBuilder: SystemBuilder) -> some View {
        QuantifiableView(systemBuilder.digitalBuilders) { digitals in
            Section("Digital") {
                SortedSetView(digitals) { digital in
                    Button(action: {
                        self.update(digital)
                    }, label: {
                        CheckMarkView(digital.rawValue, isVisible: contains(digital))
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    private func PhysicalView(_ systemBuilder: SystemBuilder) -> some View {
        WrapperView(systemBuilder.physicalBuilder) { physical in
            Section("Physical") {
                Toggle(physical.rawValue, isOn: .init(get: {
                    self.contains(physical)
                }, set: { _ in
                    self.update(physical)
                }))
            }
        }
    }
    
    @ViewBuilder
    private func PlatformLabel() -> some View {
        SpacedLabel("Platform", self.display, self.emphasis)
    }
    
}

fileprivate struct SelectPlatformView: AddPlatformProtocol {
    
    @EnvironmentObject var builder: GameBuilder
    @EnvironmentObject var object: AddPlatform

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            ForEach(SystemEnum.cases) { systemEnum in
                QuantifiableView(self.get(systemEnum)) { builders in
                    Section(systemEnum.rawValue) {
                        SortedSetView(builders, content: ButtonView)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func ButtonView(_ systemBuilder: SystemBuilder) -> some View {
        Button(action: {
            self.object.system = self.system == systemBuilder ? nil : systemBuilder
            self.dismiss()
        }, label: {
            CheckMarkView(systemBuilder.rawValue, isVisible: self.system == systemBuilder)
        })
    }

}

fileprivate class AddPlatform: ObservableObject {
    
    @Published var system: SystemBuilder?
    @Published var formats: Formats
    
    let used: [SystemBuilder]
    let isNavigationLinkDisabled: Bool

    init(_ builder: GameBuilder, _ system: SystemBuilder?) {
        self.system = system
        self.formats = builder.tags.get(system)
        self.used = builder.tags.systems
        self.isNavigationLinkDisabled = system != nil
    }
    
    var count: Int {
        var c: Int = 0
        self.formats.forEach { c = c + $0.value.count }
        return c
    }
    
}

fileprivate protocol AddPlatformProtocol: Gameopticable {
    var object: AddPlatform { get }
}

fileprivate extension AddPlatformProtocol {
    
    func contains(_ format: FormatBuilder) -> Bool {
        self.object.formats.contains(format)
    }
    
    func update(_ element: FormatBuilder) -> Void {
        if contains(element) {
            self.object.formats -= element
        } else {
            self.object.formats += element
        }
    }
    
    func get(_ system: SystemEnum) -> SortedSet<SystemBuilder> {
        .init(SystemBuilder.filter(system).filter { self.object.used.lacks($0) })
    }
    
    var system: SystemBuilder? { self.object.system }
    var display: String { self.system?.rawValue ?? .defaultValue }
    var emphasis: SpacedLabel.Emphasis { self.system == nil ? .left : .right }
    var isNavigationLinkDisabled: Bool { self.object.isNavigationLinkDisabled }
    var navigationTitle: String { "\(self.isNavigationLinkDisabled ? "Edit" : "Add") Platform" }

    var isDoneDisabled: Bool {
        let isUnchanged: Bool = self.builder.tags.get(system) == self.object.formats
        let isNull: Bool = self.system == nil
        let isEmpty: Bool = self.object.formats.isEmpty
        return isUnchanged || isNull || isEmpty
    }
    
    var element: Systems.Element? {
        if let system: SystemBuilder = self.system {
            return .init(system, self.object.formats)
        } else {
            return nil
        }
    }
    
}



private struct AddPlatformViewPreview: View {
    
    @StateObject var builder: GameBuilder = .init(.library)
    
    var body: some View {
        NavigationStack {
            Form {
                Text("builder count: \(self.builder.tags.quantity)")
                
                Section {
                    ForEach(self.builder.tags.builders) { t in
                        switch t {
                        case .input(let i):
                            FormattedView(i.type.rawValue, i.string)
                        case .mode(let m):
                            FormattedView("Mode", m.rawValue)
                        case .platform(let p):
                            FormattedView(p.system.rawValue, p.format.rawValue)
                        }
                    }
                }

                SortedSetView(SystemEnum.self) { systemEnum in
                    Section(systemEnum.rawValue) {
                        ForEach(SystemBuilder.cases.filter { $0.type == systemEnum}) { systemBuilder in
                            NavigationLink(destination: {
                                AddPlatformView(self.builder, systemBuilder)
                            }, label: {
                                Text(systemBuilder.rawValue)
                            })
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
}

#Preview {
    AddPlatformViewPreview()
}
