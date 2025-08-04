////
////  TestingView.swift
////  autosave
////
////  Created by Asia Serrano on 5/18/25.
////
//
//import SwiftUI
//
////struct FooBar: Stable {
////    
////    var int: Int
////    var bool: Bool
////    var string: String
////    
////    init() {
////        self.int = 4
////        self.bool = false
////        self.string = "string"
////    }
////    
////}
////
////protocol FooBarProtocol: ObservableObject {
////    var foobar: FooBar { get }
////}
////
////extension FooBarProtocol {
////    var int: Int { self.foobar.int }
////    var bool: Bool { self.foobar.bool }
////    var string: String { self.foobar.string }
////}
////
////class Foo: FooBarProtocol, Stable {
////    
////    @Published var foobar: FooBar = .init()
////    
////    func hash(into hasher: inout Hasher) {
////        hasher.combine(self.foobar)
////    }
////    
////}
////
////class Bar: FooBarProtocol {
////    
////    @Published var foobar: FooBar
////    
////    init(_ foobar: FooBar) {
////        self.foobar = foobar
////    }
////    
////    func equals(_ foo: Foo) -> Bool {
////        self.foobar == foo.foobar
////    }
////}
////
////enum Choice: Enumerable {
////    case int
////    case bool
////    case string
////}
//
//struct TestingView: View {
//    
//    let array: [TagContainer]
//    
//    
//    var first: TagContainer? {
//        return array.first(where: {
//            isNotValid($0)
//        })
//    }
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                
//                if let container: TagContainer = self.first {
//                    let c: [TagContainer.MapKey] = [.master, .inputs, .modes, .platforms]
//                    ForEach(c) { mapKey in
//                        let array: [TagBuilder] = container.getBuilders(mapKey).sorted()
//                        Section("\(mapKey.rawValue) - \(array.count)") {
//                            ForEach(array, content: BuilderView)
//                        }
//                    }
//                }
//                
//            }
//        
//            .toolbar {
//                
//             
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func BuilderView(_ builder: TagBuilder) -> some View {
//        switch builder {
//        case .input(let inputBuilder):
//            FormattedView(inputBuilder.type.rawValue, inputBuilder.stringBuilder.trim)
//        case .mode(let modeEnum):
//            FormattedView("Mode", modeEnum.rawValue)
//        case .platform(let platformBuilder):
//            FormattedView(platformBuilder.system.rawValue, platformBuilder.format.rawValue)
//        }
//    }
//    
//    func isNotValid(_ container: TagContainer) -> Bool {
//        let master: Int = container.getCount(.master)
//        let inputs: Int = container.getCount(.inputs)
//        let modes: Int = container.getCount(.modes)
//        let platforms: Int = container.getCount(.platforms)
//        let maps: Int = inputs + modes + platforms
//        let result: Bool = master != maps
//        
//        if result {
//            print("master: \(master)")
//            print("inputs: \(inputs)")
//            print("modes: \(modes)")
//            print("platforms: \(platforms)")
//            print("maps: \(maps)")
//        }
//        return result
//    }
//    
////    @StateObject var gameBuilder: GameBuilder = .init(.library)
////    
////    var body: some View {
////        NavigationStack {
////            Form {
////                
////                Text("count: \(self.gameBuilder.count.description)")
////                
////            }
////        
////            .toolbar {
////                
////                ToolbarItem(placement: .topBarTrailing, content: {
////                    Button("Add") {
////                        self.gameBuilder.add(.random)
////                    }
////                })
////                
////            }
////        }
////    }
//    
////    func modeBinding(_ mode: ModeEnum) -> Binding<Bool> {
////        let builder: TagBuilder = .mode(mode)
////        return .init(get: {
////            self.tags.contains(builder)
////        }, set: { newValue in
////            if newValue {
////                self.tags.add(builder)
////            } else {
////                self.tags.delete(builder)
////            }
////        })
////    }
//    
//}
//
//#Preview {
//    
//    var array: [TagContainer] {
//        var new: [TagContainer] = []
//        while new.count < 20 {
//            new.append(.random)
//        }
//        return new
//    }
//    
//    TestingView(array: array)
//}
