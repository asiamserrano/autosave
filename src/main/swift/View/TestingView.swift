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
    
    var body: some View {
        Form {
            Text(uuid.uuidString)
        }
    }
    
}

#Preview {
    TestingView()
}
