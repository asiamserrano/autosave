//
//  ContentView.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            Form {
                ForEach(self.items) { item in
                    Text(item.timestamp.description)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    
                    Button("Add") {
                        let item: Item = .init(timestamp: .now)
                        self.modelContext.insert(item)
                        try? self.modelContext.save()
                    }
                    
                })
                
            }
        }
        
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
