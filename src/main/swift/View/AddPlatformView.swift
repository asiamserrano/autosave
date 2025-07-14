//
//  AddPlatformView.swift
//  autosave
//
//  Created by Asia Serrano on 7/14/25.
//

import SwiftUI
import SwiftData
//import Views

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
            NavigationLink(destination: {
                SelectPlatformView()
            }, label: {
                FormattedView("Platform", self.display)
            })
            .disabled(self.allowEdit)
            
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
        .environmentObject(self.builder)
        .environmentObject(self.object)
        .navigationTitle(self.title)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if let element: Tags.Platforms.Element = self.element {
                        self.builder.tags.set(element)
                        self.dismiss()
                    }
                }, label: {
                    Text("Done")
                })
                .disabled(self.isDoneDisabled)
            }
            
        }
    
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
                                    self.object.system = systemBuilder
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
    @Published var formats: Set<FormatBuilder>
    
    let used: [SystemBuilder]
    let allowEdit: Bool
    
    init(_ builder: GameBuilder, _ system: SystemBuilder?) {
        self.system = system
        self.formats = builder.tags.platforms.get(system)
        self.allowEdit = system == nil
        self.used = builder.tags.platforms.enums
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
            self.object.formats.remove(element)
        } else {
            self.object.formats.insert(element)
        }
    }
    
    func get(_ system: SystemEnum) -> [SystemBuilder] {
        SystemBuilder.filter(system).filter { !self.object.used.contains($0) }
    }
    
    var allowEdit: Bool { self.object.allowEdit }
    var system: SystemBuilder? { self.object.system }
    var display: String { self.system?.rawValue ?? .defaultValue }
    var title: String { "\(self.allowEdit ? "Edit" : "Add") Platform" }

    var isDoneDisabled: Bool {
        self.builder.tags.platforms.get(system) == self.object.formats
    }
    
    var element: Tags.Platforms.Element? {
        if let system: SystemBuilder = self.system {
            return (system, self.object.formats)
        } else {
            return nil
        }
    }
    
}
