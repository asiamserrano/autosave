//
//  AddInputView.swift
//  autosave
//
//  Created by Asia Serrano on 8/14/25.
//

import SwiftUI
import SwiftData

struct AddInputView: InputObjectProtocol {
    
    @ObservedObject var builder: GameBuilder
    
    @StateObject fileprivate var object: InputObject
        
    init(_ builder: GameBuilder, _ input: InputEnum, _ used: SortedSet<String>) {
        self.builder = builder
        self._object = .init(wrappedValue: .init(input, used))
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private struct QueryView: InputObjectProtocol {
        
        @Environment(\.dismiss) var dismiss
        
        @EnvironmentObject public var builder: GameBuilder
        @EnvironmentObject fileprivate var object: InputObject
        
        @Query var models: [PropertyModel]
        @Query var searchResults: [PropertyModel]
        
        init(_ input: InputEnum, _ used: SortedSet<String>, _ binding: Binding<String>) {
            self._models = .init(filter: .getByLabel(input, binding, used), sort: .defaultValue)
            self._searchResults = .init(filter: .getByInput(input, binding))
        }
        
        var body: some View {
            Form {
                Section(content: AddButton)
                    .show(searchResults.isEmpty && search.isOccupied)
                
                Section {
                    ForEach(models) { model in
                        WrapperView(model.value_trim, content: StringView)
                    }
                }
                
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: self.done, label: {
                        CustomText(.done)
                    })
                    .disabled(self.equals(.none))
                }
                
            }
        }
        
        @ViewBuilder
        private func StringView(_ string: String) -> some View {
            WrapperView(.string(string)) { (stringBuilder: StringBuilder) in
                Button(action: {
                    self.update(stringBuilder)
                }, label: {
                    CheckMarkView(stringBuilder, isVisible: self.equals(stringBuilder))
                })
            }
        }
        
        @ViewBuilder
        private func AddButton() -> some View {
            Button(action: {
                self.update(.string(search))
                self.done()
            }, label: {
                Text("Add \'\(search.trimmed)\'")
            })
        }
        
        private func done() -> Void {
//            if let selected: StringBuilder = self.selected {
//                var inputs: Inputs = self.builder.
//                let inputBuilder: InputBuilder = .init(input, selected.trim)
//                let tagBuilder: TagBuilder = .input(inputBuilder)
//                self.builder.add(tagBuilder)
//            }
            self.dismiss()
        }
        
    }
}

fileprivate class InputObject: ObservableObject {
    
    @Published var search: String = .defaultValue
    @Published var selected: StringBuilder? = .none
    
    let input: InputEnum
    let used: SortedSet<String>
    
    init(_ i: InputEnum, _ u: SortedSet<String>) {
        self.input = i
        self.used = u
    }
    
}

fileprivate protocol InputObjectProtocol: Gameopticable {
    var object: InputObject { get }
}

fileprivate extension InputObjectProtocol {
    
    var input: InputEnum { self.object.input }
    var used: SortedSet<String> { self.object.used }
    var search: String { self.object.search }
    var selected: StringBuilder? { self.object.selected }
    
    var prompt: String {
        let str: String = self.input.rawValue.lowercased()
        return "search or add new \(str)"
    }
    
    var navigationTitle: String {
        "Add \(self.input.rawValue)"
    }
    
    func equals(_ other: StringBuilder?) -> Bool {
        self.selected == other
    }
    
    func update(_ string: StringBuilder) -> Void {
        self.object.selected = self.equals(string) ? nil : string
    }
    
}


//
//#Preview {
//    AddInputView()
//}
