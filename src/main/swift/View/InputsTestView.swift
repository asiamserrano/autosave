////
////  InputsTestView.swift
////  autosave
////
////  Created by Asia Serrano on 8/15/25.
////
//
//import SwiftUI
//
//struct InputsTestView: View {
//    
//    @State var inputs: InputsSortedMap = .random
//    
//    var body: some View {
//        
//        NavigationStack {
//            Form {
//                
//                Section("Inputs") {
//                    QuantifiableView(inputs.keys) { keys in
//                        ForEach(inputs.keys) { input in
//                            NavigationLink(destination: {
//                                InputsTestNavView(input, $inputs)
//                            }, label: {
//                                Text(input.rawValue)
//                            })
//                        }
//                        .onDelete(perform: { indexSet in
//                            indexSet.forEach {
//                                inputs[keys[$0]] = nil
//                            }
//                        })
//                    }
//                }
//                
//                ForEach(inputs.builders) {
//                    WrapperView($0.key.builder) { builder in
//                        FormattedView(builder.label.rawValue, builder.value.trim)
//                    }
//                }
//            }
//        }
//        
//    }
//}
//
//fileprivate struct InputsTestNavView: View {
//    
//    @Environment(\.dismiss) private var dismiss
//    
//    @Binding var inputs: InputsSortedMap
//    
//    let key: InputEnum
//    let hash: Int
//    
//    @State var builders: StringBuilders
//    
//    init(_ key: InputEnum, _ inputs: Binding<InputsSortedMap>) {
//        let original: StringBuilders = inputs.wrappedValue.get(key)
//        self.hash = original.hashValue
//        self._builders = .init(initialValue: original)
//        self._inputs = inputs
//        self.key = key
//    }
//    
//    var body: some View {
//        
//        NavigationStack {
//            Form {
//                Section(key.rawValue) {
//                    ForEach(builders) { string in
//                        Text(string.trim)
//                    }
//                    .onDelete(perform: { indexSet in
//                        indexSet.forEach {
//                            self.builders -= $0
//                        }
//                    })
//                }
//            }
//            .navigationBarBackButtonHidden()
//            .toolbar {
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Back") {
//                        if self.hash != self.builders.hashValue {
//                            self.inputs[self.key] = self.builders
//                            print("updating")
//                        }
//                        self.dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Add") {
//                        self.builders += .string(.random)
//                    }
//                }
//                
//            }
//        }
//    }
//}
//
//#Preview {
//    InputsTestView()
//}
