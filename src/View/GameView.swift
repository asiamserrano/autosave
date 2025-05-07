//
//  GameView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State var snapshot: GameSnapshot
    
    init(_ snaphot: GameSnapshot) {
        self._snapshot = .init(wrappedValue: snaphot)
    }
    
    var body: some View {
        Form {
            Section {
                FormattedView("Title", self.snapshot.title)
                FormattedView("Release Date", self.snapshot.release.long)
            }
        }
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: {
                    GameForm(self.snapshot, onSave: self.onSave)
                }, label: {
                    Text("Edit")
                })
            })
            
        }
    }
    
    // TODO: This is not working
    func onSave(_ input: GameSnapshot) -> GameModel {
        let model: GameModel = self.modelContext.save(input)
        self.snapshot = model.snapshot
        return model
    }
    
    @ViewBuilder
    func FormattedView(_ key: String, _ value: String) -> some View {
        HStack {
            HStack {
                Text(key)
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(width: 95)
            Text(value)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
    }
    
}
