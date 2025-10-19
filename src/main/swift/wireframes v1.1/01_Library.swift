//
//  01_Library.swift
//  autosave
//
//  Created by Asia Serrano on 10/17/25.
//

import SwiftUI
import SwiftData

struct Library: View {
        
    @State private var searchString: String = ""

    var body: some View {
        NavigationStack {
            Form {
                
                ForEach(0..<20) { _ in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(String.random)
                            .bold()
                        HStack {
                            HStack(spacing: 8) {
                                Icon
                                Text(Date.random.dashes)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                }
                
            }
            .navigationTitle(Text(String.random))
            .searchable(text: $searchString)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Icon
                })
                
                ToolbarItem(placement: .topBarLeading, content: {
                    Icon
                })
                
            }
        }
    }
    
}

#Preview {
    
    Library()
    
}
