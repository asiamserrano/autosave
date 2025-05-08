//
//  GameForm.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI

struct GameForm: View {
    
    @Environment(\.modelContext) private var modelContext
        
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var builder: GameBuilder
    
    init(_ builder: GameBuilder) {
        self._builder = .init(wrappedValue: builder)
    }
    
    init() {
        let builder: GameBuilder = .init(.defaultValue)
        self.init(builder)
    }
        
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $builder.title)
                }
                Section {
                    DatePicker("Release Date", selection: $builder.release, displayedComponents: .date)
                }
                
                Text("isDisabled: \(self.builder.isDisabled.description)")
            }
            .navigationBarBackButtonHidden()
//            .navigationTitle(self.type.rawValue)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        self.builder.reset()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let result: GameResult = self.modelContext.save(self.builder)
                        if result.successful {
                            self.dismiss()
                        } else {
                            print("failed")
                            self.builder.fail()
                        }
                    }
                    .disabled(self.builder.isDisabled)
                }
            }
        }
    }
}
