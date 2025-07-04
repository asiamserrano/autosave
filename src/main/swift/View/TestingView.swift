//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {
 
    @State var bool: Bool = true
    
    var body: some View {
        NavigationStack {
            Form {
                
                BooleanView(self.bool, {
                    Text("True View")
                }, {
                    Text("False View")
                })
                
                
//                Section {
//                    Text(self.tags.hashValue.description)
//                    Text(self.original.hashValue.description)
//                    
//                }
//                
//                ForEach(ModeEnum.cases) { mode in
//                    Toggle(isOn: modeBinding(mode), label: {
//                        Text(mode.rawValue)
//                    })
//                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Toggle") {
                        self.bool = !self.bool
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
