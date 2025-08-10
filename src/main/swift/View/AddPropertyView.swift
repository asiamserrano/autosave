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

public struct AddPropertyView: AddPropertyProtocol {
    
    @ObservedObject public var builder: GameBuilder
    
    @StateObject fileprivate var object: AddProperty
    
    init(_ builder: GameBuilder, _ input: InputEnum, _ used: SortedSet<String>) {
        self.builder = builder
        self._object = .init(wrappedValue: .init(input, used))
    }
    
    private var binding: Binding<String> {
        self.$object.search
    }
    
    public var body: some View {
        QueryView(input, used, binding)
            .environmentObject(builder)
            .environmentObject(object)
            .searchable(text: binding, placement: .navigationBarDrawer(displayMode: .always), prompt: prompt)
    }
    
    private struct QueryView: AddPropertyProtocol {
        
        @Environment(\.dismiss) var dismiss
        
        @EnvironmentObject public var builder: GameBuilder
        @EnvironmentObject fileprivate var object: AddProperty
        
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
            if let selected: StringBuilder = self.selected {
                let inputBuilder: InputBuilder = .init(input, selected.trim)
                let tagBuilder: TagBuilder = .input(inputBuilder)
                self.builder.add(tagBuilder)
            }
            self.dismiss()
        }
        
    }
    
}

fileprivate class AddProperty: ObservableObject {
    
    @Published var search: String = .defaultValue
    @Published var selected: StringBuilder? = .none
    
    let input: InputEnum
    let used: SortedSet<String>
    
    init(_ i: InputEnum, _ u: SortedSet<String>) {
        self.input = i
        self.used = u
    }
    
}

fileprivate protocol AddPropertyProtocol: Gameopticable {
    var object: AddProperty { get }
}

fileprivate extension AddPropertyProtocol {
    
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

