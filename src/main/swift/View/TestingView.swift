//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {
    
    @State var tags: Tags = .random
    
    let game: GameSnapshot = 
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(self.tags.hashValue.description)
                }
                ForEach(ModeEnum.cases) { mode in
                    Toggle(isOn: modeBinding(mode), label: {
                        Text(mode.rawValue)
                    })
                }
            }
        }
    }
    
    func modeBinding(_ mode: ModeEnum) -> Binding<Bool> {
        let builder: TagBuilder = .mode(mode)
        return .init(get: {
            self.tags.contains(builder)
        }, set: { newValue in
            if newValue {
                self.tags.add(builder)
            } else {
                self.tags.delete(builder)
            }
        })
    }
    
}

#Preview {
    TestingView()
}
