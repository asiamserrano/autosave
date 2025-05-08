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
                    CustomTextField(.title, $builder.title)
                }
                Section {
                    CustomDatePicker(.release_date, $builder.release)
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    CustomButton(.cancel) {
                        self.builder.cancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    CustomButton(.done) {
                        let result: GameResult = self.modelContext.save(self.builder)
                        if result.successful {
                            self.dismiss()
                        } else {
                            self.builder.fail()
                        }
                    }
                    .disabled(self.builder.isDisabled)
                }
            }
        }
    }
}
