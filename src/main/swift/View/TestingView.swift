//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 8/17/25.
//

import SwiftUI

struct TestingView: View {
    
    @StateObject var game: GameBuilder = .init(.library)
    
    var tags: Tags { self.game.tags }
    
    var body: some View {
        NavigationStack {
            Form {
                
                FormattedView("Builders Count", tags.quantity)
                
                Section {
                    QuantifiableView(tags.inputs.keys) { inputs in
                        SortedSetView(inputs) { input in
                            DisclosureGroup(content: {
                                QuantifiableView(tags[input]) { strings in
                                    SortedSetView(strings) { string in
                                        Text(string.rawValue)
                                    }
                                    .onDelete(action: { indexSet in
                                        indexSet.forEach {
                                            let i: InputBuilder = .init(input, strings[$0])
                                            self.game.delete(.input(i))
                                        }
                                    })
                                }
                            }, label: {
                                Text(input.rawValue)
                            })
                        }
                        .onDelete(action: { indexSet in
                            indexSet.forEach {
                                self.game.delete(inputs[$0])
                            }
                        })
                    }
                }
                
                
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Add") {
                        self.game.add(.input(.random))
                    }
                })
                
            }
        }
    }
    
    private func random(_ category: TagCategory) -> TagBuilder {
        print("adding \(category.rawValue)")
        switch category {
        case .input: return .input(.random)
        case .mode: return .mode(.random)
        case .platform: return .platform(.random)
        }
    }
    
    @ViewBuilder
    private func OldView() -> some View {
        SortedSetView(TagCategory.self) { category in
            WrapperView(category.rawValue.pluralize()) { title in
                NavigationLink(destination: {
                    Form {
                        switch category {
                        case .input: InputsView()
                        case .mode: ModesView()
                        case .platform: PlatformsView()
                        }
                    }
                    .navigationTitle(title)
                }, label: {
                    Text(title)
                })
            }
        }
    }
    
    @ViewBuilder
    private func BuildersView() -> some View {
        QuantifiableView(tags.builders) { builders in
            Section("Builders") {
                SortedSetView(builders) { builder in
                    switch builder {
                    case .input(let input):
                        FormattedView(input.type.rawValue, input.string)
                    case .mode(let mode):
                        FormattedView("Mode", mode.rawValue)
                    case .platform(let platform):
                        FormattedView(platform.system.rawValue, platform.format.rawValue)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func InputsView() -> some View {
        QuantifiableView(tags.inputs) { inputs in
            Section {
                SortedSetView(inputs.keys) { input in
                    NavigationLink(destination: {
                        Form {
                            QuantifiableView(tags[input]) { strings in
                                
                                SortedSetView(strings) { string in
                                    Text(string.rawValue)
                                }
                                .onDelete(action: { indexSet in
                                    indexSet.forEach {
                                        let i: InputBuilder = .init(input, strings[$0])
                                        self.game.delete(.input(i))
                                    }
                                })
                            }
                        }
                    }, label: {
                        Text(input.rawValue)
                    })
                }
//                .onDelete(action: { indexSet in
//                    indexSet.forEach {
//                        tags -= inputs[$0]
//                    }
//                })
            }
        }
    }
    
    @ViewBuilder
    private func ModesView() -> some View {
        QuantifiableView(tags.modes) { modes in
            Section {
                SortedSetView(modes.elements) { mode in
                    Text(mode.rawValue)
                }
                .onDelete(action: { indexSet in
                    indexSet.forEach {
                        self.game.delete(.mode(modes[$0]))
                    }
                })
            }
        }
    }
    
    @ViewBuilder
    private func PlatformsView() -> some View {
        QuantifiableView(tags.platforms.keys) { systemEnums in
            SortedSetView(systemEnums) { systemEnum in
                Section(systemEnum.rawValue) {
                    QuantifiableView(tags[systemEnum].keys) { systemBuilders in
                        SortedSetView(systemBuilders, content: SystemsView)
                            .onDelete(action: { indexSet in
                                indexSet.forEach {
                                    self.game.delete(systemBuilders[$0])
                                }
                            })
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func SystemsView(_ system: SystemBuilder) -> some View {
        DisclosureGroup(content: {
            QuantifiableView(tags[system].keys) { formatEnums in
                SortedSetView(formatEnums) { formatEnum in
                    FormatsView(system, formatEnum)
                }
                .onDelete(action: { indexSet in
                    indexSet.forEach {
                        self.game.delete(system, formatEnums[$0])
                    }
                })
                
            }
        }, label: {
            Text(system.rawValue)
        })
    }
    
    @ViewBuilder
    private func FormatsView(_ system: SystemBuilder, _ format: FormatEnum) -> some View {
        DisclosureGroup(content: {
            QuantifiableView(tags[(system, format)], content: { formatBuilders in
                SortedSetView(formatBuilders) { formatBuilder in
                    Text(formatBuilder.rawValue)
                }
                .onDelete(action: { indexSet in
                    indexSet.forEach {
                        let p: PlatformBuilder = .init(system, formatBuilders[$0])
                        self.game.delete(p)
                    }
                })
            })
        }, label: {
            Text(format.rawValue)
        })
    }
    
}

#Preview {
    TestingView()
}


/*
 Form {
//                QuantifiableView(inputs.keys) { keys in
//                    SortedSetView(keys) { key in
//                        NavigationLink(destination: {
//                            Form {
//                                QuantifiableView(inputs[key]) { strings in
//                                    SortedSetView(strings, content: { string in
//                                        Text(string.trim)
//                                    })
//                                    .onDelete(action: { indexSet in
//                                        indexSet.forEach {
//                                            inputs -= (key, strings[$0])
//                                        }
//                                    })
//                                }
//                            }
//                        }, label: {
//                            Text(key.rawValue)
//                        })
//
//                    }
//                    .onDelete(action: { indexSet in
//                        indexSet.forEach {
//                            inputs -= keys[$0]
//                        }
//                    })
//                }
     
     QuantifiableView(tags.inputs.keys) { keys in
         SortedSetView(keys) { key in
             NavigationLink(destination: {
                 Form {
                     QuantifiableView(tags[key]) { strings in
                         SortedSetView(strings) { string in
                             Text(string.trim)
                         }
                         .onDelete(action: { indexSet in
                             indexSet.forEach {
                                 tags -= .input(.init(key, strings[$0]))
                             }
                         })
                     }
                 }
             }, label: {
                 Text(key.rawValue)
             })
         }
         .onDelete(action: { indexSet in
             indexSet.forEach {
                 tags[keys[$0]] = .defaultValue
             }
         })
     }
 }
 */
