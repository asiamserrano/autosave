//
//  autosaveApp.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

@main
struct autosaveApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        
    }
    
}

fileprivate struct ContentView: View {
        

    var body: some View {
        NavigationStack {
            Text("Hello, World!")
        }
    }
    
}


#Preview {
    
    ContentView()
    
}
