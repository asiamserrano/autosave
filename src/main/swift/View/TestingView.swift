//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(RelationType.cases) { bar in
                        Text(bar.id)
                    }
                }
                Section {
                    ForEach(TagType.cases) { bar in
                        Text(bar.id)
                    }
                }
            }
        }
    }
    
}

#Preview {
    TestingView()
}
