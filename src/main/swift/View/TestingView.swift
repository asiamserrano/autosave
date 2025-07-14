//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct FooBar: Stable {
    
    var int: Int
    var bool: Bool
    var string: String
    
    init() {
        self.int = 4
        self.bool = false
        self.string = "string"
    }
    
}

protocol FooBarProtocol: ObservableObject {
    var foobar: FooBar { get }
}

extension FooBarProtocol {
    var int: Int { self.foobar.int }
    var bool: Bool { self.foobar.bool }
    var string: String { self.foobar.string }
}

class Foo: FooBarProtocol, Stable {
    
    @Published var foobar: FooBar = .init()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.foobar)
    }
    
}

class Bar: FooBarProtocol {
    
    @Published var foobar: FooBar
    
    init(_ foobar: FooBar) {
        self.foobar = foobar
    }
    
    func equals(_ foo: Foo) -> Bool {
        self.foobar == foo.foobar
    }
}

enum Choice: Enumerable {
    case int
    case bool
    case string
}

struct TestingView: View {
    
    @ObservedObject var foo: Foo
    @StateObject var bar: Bar
    
    init(_ foo: Foo = .init()) {
        self.foo = foo
        self._bar = .init(wrappedValue: .init(foo.foobar))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Text("equals: \(self.bar.equals(self.foo))")
                
                Section("Foo") {
                    Text(self.foo.int.description)
                    Text(self.foo.bool.description)
                    Text(self.foo.string)
                }
                
                Section("Bar") {
                    Text(self.bar.int.description)
                    Text(self.bar.bool.description)
                    Text(self.bar.string)
                }
                
            }
        
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Change") {
                        switch Choice.random {
                        case .int:
                            self.bar.foobar.int = .random(in: 0...100000)
                        case .bool:
                            self.bar.foobar.bool = !self.bar.bool
                        case .string:
                            self.bar.foobar.string = .random
                        }
                    }
                })
                
            }
        }
    }
    
//    func modeBinding(_ mode: ModeEnum) -> Binding<Bool> {
//        let builder: TagBuilder = .mode(mode)
//        return .init(get: {
//            self.tags.contains(builder)
//        }, set: { newValue in
//            if newValue {
//                self.tags.add(builder)
//            } else {
//                self.tags.delete(builder)
//            }
//        })
//    }
    
}

#Preview {
    TestingView()
}
