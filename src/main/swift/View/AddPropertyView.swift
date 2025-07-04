//
//  AddPropertyView.swift
//  cancun
//
//  Created by Asia Serrano on 6/30/24.
//

import SwiftUI
import SwiftData

struct AddPropertyView: Gameopticable {
    
//    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var builder: GameBuilder
    
    @State var search: String = .defaultValue
    @State var selected: StringBuilder? = .none
    
    let input: InputEnum
    let used: [String]
    
    init(_ builder: GameBuilder, _ input: InputEnum, _ used: [String]) {
        self.builder = builder
        self.input = input
        self.used = used
    }
    
    private var stringBuilder: StringBuilder {
        .string(self.search)
    }
    
    private var prompt: String {
        "search or add new \(input.rawValue.lowercased())"
    }
    
    var body: some View {
        AddView(input, used, $search)
            .environmentObject(self.builder)
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: Text(prompt))
    }

    
    
    private struct AddView: Gameopticable {
        
        @Environment(\.dismiss) var dismiss
        
        @EnvironmentObject public var builder: GameBuilder
        
        @Query var models: [PropertyModel]
        
        @State var selected: StringBuilder? = .none
        
        let search: String
        
        init(_ input: InputEnum, _ used: [String], _ binding: Binding<String>) {
            let predicate: PropertyPredicate = .getByLabel(input, binding, used)
            self._models = .init(filter: predicate, sort: .defaultValue)
            self.search = binding.wrappedValue
        }
        
        var body: some View {
            Form {
//                if self.search.isNotEmpty {
//                    let expression: Expression = .init(raw: self.search)
//                    if self.expressions.map({ $0.key }).notContains(expression.key) {
//                        Button(action: {
//                            self.update(expression)
//                            self.done()
//                        }, label: {
//                            Text(self.buttonLabel)
//                        })
//                    }
//                }
                
                Section {
                    ForEach(models) { model in
                        Text(model.value_trim)
                    }
//                    List(self.expressions, id:\.self) { expression in
//                        if self.validate(expression) {
//                            Button(action: {
//                                self.update(expression)
//                            }, label: {
//                                CheckMarkView(expression, self.selected != expression)
//                            })
//                        }
//                    }
                }
                
            }
//            .navigationTitle(self.navigationTitle)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Text("Done")
                    })
//                    .disabled(self.isDoneDisabled)
                }
                
            }
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
//    private var isDoneDisabled: Bool {
//        self.selected == .none
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
//    private func done() -> Void {
//        self.gameViewer.addProperty(self.inputs, self.selected)
//        self.dismiss()
//    }
//    
//    private func validate(_ expression: Expression) -> Bool {
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
//    private func update(_ expression: Expression) -> Void {
//        self.selected = self.selected == expression ? nil : expression
//    }
    
}
