//
//  TempModesView.swift
//  autosave
//
//  Created by Asia Serrano on 8/25/25.
//

import SwiftUI

struct TempModesView: View {
    
//    @State var modes: Modes = .random
    
    @StateObject var builder: GameBuilder = .random
    
//    @State var tags: Tags = .random
    
    var modes: Modes { self.builder.tags.modes }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SortedSetView(ModeEnum.self) { mode in
                        WrapperView(.mode(mode)) { (b: TagBuilder) in
                            Toggle(isOn: .init(get: {
                                self.modes.contains(mode)
                            }, set: { newValue in
                                self.boolean_action(newValue, TRUE: {
                                    self.builder.add(b)
                                }, FALSE: {
                                    self.builder.delete(b)
                                })
                            }), label: {
                                HStack {
                                    IconView(mode.icon)
                                    Text(mode.rawValue)
                                    Spacer()
                                }
                            })
                        }
                        
                    }
                }
                
                Section("Master") {
                    SortedSetView(self.builder.builders, content: FormattedView)
                }
            }
        }
    }
    
    @ViewBuilder
    private func ModeToggle(_ mode: ModeEnum) -> some View {
        Toggle(isOn: .init(get: {
            self.modes.contains(mode)
        }, set: { newValue in
            let b: TagBuilder = .mode(mode)
            self.boolean_action(newValue, TRUE: {
                self.builder.add(b)
            }, FALSE: {
                self.builder.delete(b)
            })
        }), label: {
            HStack {
                IconView(mode.icon)
                Text(mode.rawValue)
                Spacer()
            }
        })
//        HStack {
//           
//        }
        
//        Toggle(String.defaultValue, isOn: .init(get: {
//            self.modes.contains(mode)
//        }, set: { newValue in
//            let b: TagBuilder = .mode(mode)
//            self.boolean_action(newValue, TRUE: {
//                self.builder.add(b)
////                self.tags += b
//            }, FALSE: {
//                self.builder.delete(b)
////                self.tags -= b
//            })
//        }))
    }
    
}

#Preview {
    TempModesView()
}
