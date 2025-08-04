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
            
            BooleanView(self.isNavigationLinkDisabled, trueView: PlatformLabel, falseView: {
                NavigationLink(destination: {
                    SelectPlatformView()
                        .environmentObject(self.builder)
                        .environmentObject(self.object)
                }, label: PlatformLabel)
            })
            
            OptionalObjectView(self.system, content: { system in
                OptionalArrayView(system.digitalBuilders) { digitals in
                    Section("Digital") {
                        ForEach(digitals.sorted()) { digital in
                            Button(action: {
                                self.update(digital)
                            }, label: {
                                CheckMarkView(digital.rawValue, isVisible: contains(digital))
                            })
                        }
                    }
                }
                
                OptionalObjectView(system.physicalBuilder, content: { physical in
                    Section("Physical") {
                        Toggle(physical.rawValue, isOn: .init(get: {
                            self.contains(physical)
                        }, set: { _ in
                            self.update(physical)
                        }))
                    }
                })
            })
            
        }
        .navigationTitle(self.navigationTitle)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if let element: Systems.Element = self.element {
                        self.builder.set(element)
                        self.dismiss()
                    }
                }, label: {
                    CustomText(.done)
                })
                .disabled(self.isDoneDisabled)
            }
            
        }
    
    }
    
    @ViewBuilder
    private func PlatformLabel() -> some View {
        SpacedLabel("Platform", self.display, self.emphasis)
    }
    
    private struct SelectPlatformView: AddPlatformProtocol {
        
        @EnvironmentObject var builder: GameBuilder
        @EnvironmentObject var object: AddPlatform

        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            Form {
                ForEach(SystemEnum.cases) { systemEnum in
                    
                    OptionalArrayView(self.get(systemEnum)) { builders in
                        Section(systemEnum.rawValue) {
                            ForEach(builders, id:\.hashValue) { systemBuilder in
                                Button(action: {
                                    self.object.system = self.system == systemBuilder ? nil : systemBuilder
                                    self.dismiss()
                                }, label: {
                                    CheckMarkView(systemBuilder.rawValue, isVisible: self.system == systemBuilder)
                                })
                            }
                        }
                    }
                }
            }
           
        }

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
        self.used = builder.tags.platforms.systemKeys
        self.isNavigationLinkDisabled = system != nil
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
    
    func get(_ system: SystemEnum) -> [SystemBuilder] {
        SystemBuilder.filter(system).filter { self.object.used.lacks($0) }
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
            return (system, self.object.formats)
        } else {
            return nil
        }
    }
    
}
