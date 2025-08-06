//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {
    
    @State var sortedSet: SortedSet<TagBuilder> = .init()

    var body: some View {
        NavigationStack {
            Form {
                
                ForEach(self.sortedSet) {
                    BuilderView($0)
                }
                
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Add") {
                        let a: TagBuilder = create()
                        let b: TagBuilder = create()
                        print("____________________")
                        let new: SortedSet<TagBuilder> = .init(a, b)
                        self.sortedSet += new
                    }
                })
             
            }
        }
    }
    
    func create() -> TagBuilder {
        let b: TagBuilder = .random
        switch b {
        case .input(let inputBuilder):
            print(inputBuilder.type.rawValue + " " + inputBuilder.stringBuilder.trim)
        case .mode(let modeEnum):
            print("Mode" + " " + modeEnum.rawValue)
        case .platform(let platformBuilder):
            print(platformBuilder.system.rawValue + " " + platformBuilder.format.rawValue)
        }
        return b
    }
    
    @ViewBuilder
    func BuilderView(_ builder: TagBuilder) -> some View {
        switch builder {
        case .input(let inputBuilder):
            FormattedView(inputBuilder.type.rawValue, inputBuilder.stringBuilder.trim)
        case .mode(let modeEnum):
            FormattedView("Mode", modeEnum.rawValue)
        case .platform(let platformBuilder):
            FormattedView(platformBuilder.system.rawValue, platformBuilder.format.rawValue)
        }
    }
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
    
//    @StateObject var gameBuilder: GameBuilder = .init(.library)
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                
//                Text("count: \(self.gameBuilder.count.description)")
//                
//            }
//        
//            .toolbar {
//                
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    Button("Add") {
//                        self.gameBuilder.add(.random)
//                    }
//                })
//                
//            }
//        }
//    }
    
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
    
    var array: [TagContainer] {
        var new: [TagContainer] = []
        while new.count < 20 {
            new.append(.random)
        }
        return new
    }
    
    TestingView()
}
