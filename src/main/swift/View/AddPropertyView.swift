////
////  AddPropertyView.swift
////  cancun
////
////  Created by Asia Serrano on 6/30/24.
////
//
import SwiftUI
import SwiftData

//struct AddPropertyView: View {
//    
//    init(_ builder: GameBuilder, _ input: InputEnum, _ used: [String]) {
//        
////        self.builder = builder
////        self._object = .init(wrappedValue: .init(input, used))
//    }
//    
//    var body: some View {
//        Text("TBD")
//    }
//    
//}
//
//

struct AddPropertyView: AddPropertyProtocol {
        
    @ObservedObject var builder: GameBuilder
    
    @StateObject fileprivate var object: AddProperty
    
    init(_ builder: GameBuilder, _ input: InputEnum, _ used: [String]) {
        self.builder = builder
        self._object = .init(wrappedValue: .init(input, used))
    }
    
    private var binding: Binding<String> {
        self.$object.search
    }
    
    var body: some View {
        AddView(input, used, binding)
            .environmentObject(self.builder)
            .environmentObject(self.object)
            .searchable(text: binding, placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "search or add new \(input.rawValue.lowercased())")
    }
    
    private struct AddView: AddPropertyProtocol {
        
        @Environment(\.dismiss) var dismiss
        
        @EnvironmentObject public var builder: GameBuilder
        @EnvironmentObject fileprivate var object: AddProperty
        
        @Query var models: [PropertyModel]
        @Query var searchResults: [PropertyModel]

        init(_ input: InputEnum, _ used: [String], _ binding: Binding<String>) {
            self._models = .init(filter: .getByLabel(input, binding, used), sort: .defaultValue)
            self._searchResults = .init(filter: .getByInput(input, binding))
        }
        
        var body: some View {
            Form {
                if searchResults.isEmpty && search.isNotEmpty {
                    Section {
                        Button(action: {
                            self.update(.string(search))
                            self.done()
                        }, label: {
                            Text("Add \'\(search.trimmed)\'")
                        })
                    }
                }
                
                Section {
                    ForEach(models) { model in
                        BuilderView(.string(model.value_trim))
                    }
                }
            }
            .navigationTitle("Add \(self.input.rawValue)")
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: self.done, label: {
                        Text("Done")
                    })
                    .disabled(self.equals(.none))
                }
                
            }
        }
        
        private func done() -> Void {
            if let selected: StringBuilder = self.selected {
                let inputBuilder: InputBuilder = .init(input, selected.trim)
                let tagBuilder: TagBuilder = .input(inputBuilder)
                self.builder.add(tagBuilder)
            }
            self.dismiss()
        }
        
        private func update(_ string: StringBuilder) -> Void {
            self.object.selected = self.equals(string) ? nil : string
        }
        
        private func equals(_ other: StringBuilder?) -> Bool {
            self.selected == other
        }
        
        @ViewBuilder
        private func BuilderView(_ string: StringBuilder) -> some View {
            Button(action: {
                self.update(string)
            }, label: {
                CheckMarkView(string, isVisible: self.equals(string))
            })
        }
    
    }
    
}


fileprivate class AddProperty: ObservableObject {
    
    @Published var search: String = .defaultValue
    @Published var selected: StringBuilder? = .none

    let input: InputEnum
    let used: [String]
    
    init(_ i: InputEnum, _ u: [String]) {
        self.input = i
        self.used = u
    }
    
}

fileprivate protocol AddPropertyProtocol: Gameopticable {
    var object: AddProperty { get }
}

fileprivate extension AddPropertyProtocol {
    
    var input: InputEnum { self.object.input }
    var used: [String] { self.object.used }
    var search: String { self.object.search }
    var selected: StringBuilder? { self.object.selected }
    
}



//    let input: InputEnum
//    let used: Inputs.Value
//
//    init(_ gameViewer: GameViewer, _ input: InputEnum) {
//
//        let predicate: PropertyPredicate = .getByRelations(relations)
//
//        self.gameViewer = gameViewer
//        self.inputs = inputs
//        self.used = gameViewer.inputs.get(inputs) ?? .init()
//        self._query = Query(.init(predicate: .enumeration(inputs.tag), sortBy: []))
//    }
//
//    private var expressions: Expressions {
//        self.query
//            .map { $0.expression }
//            .filter { self.used.notContains($0) }
//            .sorted()
//    }
//
//    private var navigationTitle: String {
//        "Add \(self.inputs.display)"
//    }
//
//    private var buttonLabel: String {
//        "Add \'\(self.trimmed)\'"
//    }
//
//


//    private func validate(_ model: PropertyModel) -> Bool {
//        if self.selected == expression {
//            return true
//        } else {
//            let key: String = expression.key
//
//            switch self.canon.count {
//            case 0: return true
//            case 1: return key.first == self.canon.first
//            default: return key.contains(self.canon)
//            }
//        }
//
//    }
//

