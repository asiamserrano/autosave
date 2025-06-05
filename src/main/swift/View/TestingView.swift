//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {

    var uuid: UUID {
        .init(uuidString: "42B0A2F1-0D33-406D-B947-6D77F945396B")!
    }
    
    var relations: [RelationBase] {
        RelationBase.cases.filter { !PlatformBase.contains($0) }
    }
    
    var body: some View {
        Form {
            ForEach(relations) {
                Text($0.rawValue)
            }
        }
    }
    
}

#Preview {
    TestingView()
}
