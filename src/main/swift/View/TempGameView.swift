//
//  TempGameView.swift
//  autosave
//
//  Created by Asia Serrano on 8/24/25.
//

import SwiftUI

final class FooBar: ObservableObject {
    
    public static var random: FooBar {
       .init(.random)
    }
    
    @Published var tags: Tags
    @Published var input: InputEnum
    
    init(_ t: Tags) {
        self.tags = t
        self.input = .defaultValue
    }

    @MainActor
    func delete(_ builder: TagBuilder) {
        // Option A: functional (preferred: easy to reason about)
        var copy = tags
        copy -= builder
        tags = copy                  // ← one publish

        // Option B (if you have a `-` operator): tags = tags - builder
        tags = copy - builder
    }
    
    func toggle() -> Void {
        self.input = input.toggle
    }
    
    var builders: TagBuilders { self.tags.builders }
    
}

struct TempGameView: View {
    
    @State var temp: Tags = .random
    @State var input: InputEnum = .defaultValue
    
    var inputs: Inputs { temp.inputs }
    
    var body: some View {
        NavigationStack {
            Form {
                WrapperView(inputs[input]) { (strings: StringBuilders) in
                    Section(input.rawValue) {
                        ForEach(strings) { string in
                            Text(string.rawValue)
                                .tag(string)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                let value: StringBuilder = strings[index]
                                let tag: TagBuilder = .input(input, value)
                                self.temp -= tag
//                                self.temp.delete(tag)
                            }
                        })
                    }
                }
                
                Section("Master") {
                    SortedSetView(self.temp.builders, content: FormattedView)
                }
            }
            .environment(\.editMode, .constant(.active))
            .toolbar {
                
                Button("Toggle", action: {
                    self.input = input.toggle
                })
                
            }
        }
    }
    
}

//struct TempGameView: View {
//    
//    @StateObject var temp: FooBar = .random
//    
//    var inputs: Inputs { temp.tags.inputs }
//    var input: InputEnum { temp.input }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                WrapperView(inputs[input]) { (strings: StringBuilders) in
//                    Section(input.rawValue) {
//                        ForEach(strings) { string in
//                            Text(string.rawValue)
//                                .tag(string)
//                        }
//                        .onDelete(perform: { indexSet in
//                            indexSet.forEach { index in
//                                let value: StringBuilder = strings[index]
//                                let tag: TagBuilder = .input(input, value)
//                                self.temp.delete(tag)
//                            }
//                        })
//                    }
//                }
//                
//                Section("Master") {
//                    SortedSetView(self.temp.builders, content: FormattedView)
//                }
//            }
//            .environment(\.editMode, .constant(.active))
//            .toolbar {
//                
//                Button("Toggle", action: self.temp.toggle)
//                
//            }
//        }
//    }
//    
//}


//struct TempGameView: View {
//    
//    @State var input: InputEnum = .defaultValue
//    @StateObject var temp: TempGameBuilder = .random
//    
//    var inputs: Inputs { self.temp.inputs }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                WrapperView(inputs[input]) { (strings: StringBuilders) in
//                    Section(input.rawValue) {
//                        ForEach(strings) { string in
//                            Text(string.rawValue)
//                                .tag(string)
//                        }
//                        .onDelete(perform: { indexSet in
//                            indexSet.forEach { index in
//                                let value: StringBuilder = strings[index]
//                                self.temp.delete(.init(input, value))
//                            }
//                        })
//                    }
//                }
//                
//                Section("Master") {
//                    SortedSetView(self.temp.builders, content: FormattedView)
//                }
//            }
//            .environment(\.editMode, .constant(.active))
//            .toolbar {
//                
//                Button("Toggle", action: {
//                    self.input = self.input.toggle
//                })
//                
//            }
//        }
//    }
//    
//}

//struct TempGameView: View {
//    
//    @State var tagType: TagType = .defaultValue
//    @State var t: Tags
////    @StateObject var builder: FooBar
//    
//    
//    init() {
//        let tags: Tags = .random
////        self._builder = .init(wrappedValue: .init(tags.copy()))
//        self._tagType = .init(initialValue: .defaultValue)
//        self._t = .init(wrappedValue: tags.copy())
//    }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
////                Section("StateObject") {
////                    InnerView(self.tagType, self.builder.tags, { b in
////                        self.builder.delete(b)
////                    })
////                }
//                
//                Section("State") {
//                    InnerView(self.tagType, self.t, { b in
//                        self.t -= b
//                    })
//                }
//            }
//            .environment(\.editMode, .constant(.active))
//            .toolbar {
//                
//                Button("Toggle", action: {
//                    self.tagType = self.tagType.toggle
//                })
//                
//            }
//        }
//    }
//    
//    struct InnerView: View {
//        
//        let tagObj: Tags
//        let tagType: TagType
//        let action: (TagBuilder) -> Void
//        let uuid: UUID
//        
//        init(_ tagType: TagType, _ tagObj: Tags, _ action: @escaping (TagBuilder) -> Void) {
//            self.tagObj = tagObj
//            self.action = action
//            self.tagType = tagType
//            self.uuid = .init()
//        }
//        
//        var inputs: Inputs { self.tagObj.inputs }
//        
//        var body: some View {
//            OptionalView(InputEnum.convert(tagType)) { input in
//                QuantifiableView(inputs[input]) { (strings: StringBuilders) in
//                    Section(input.rawValue) {
//                        ForEach(strings) { string in
//                            Text(string.rawValue)
//                                .tag("\(string)|\(uuid.uuidString)")
//                        }
//                        .onDelete(perform: { indexSet in
//                            indexSet.forEach { index in
//                                let value: StringBuilder = strings[index]
//                                let ib: InputBuilder = .init(input, value)
//                                let tag: TagBuilder = .input(ib)
//                                action(tag)
//                            }
//                        })
//                    }
//                }
//            }
//        }
//        
//    }
//    
//}

#Preview {
    TempGameView()
}
