//
//  GameForm.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI

// TODO: This is not working
struct GameForm: View {
    
    typealias SnapshotFunc = (GameSnapshot) -> GameModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var release: Date
    
    private let hashValue: Int
    private let onSave: SnapshotFunc
    private let type: TypeEnum
    
    init(_ snaphot: GameSnapshot, onSave: @escaping SnapshotFunc) {
        self.init(snaphot, .edit, onSave: onSave)
    }
    
    init(onSave: @escaping SnapshotFunc) {
        let snapshot: GameSnapshot = .defaultValue(.defaultValue)
        self.init(snapshot, .add, onSave: onSave)
    }
        
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                }
                Section {
                    DatePicker("Release Date", selection: $release, displayedComponents: .date)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationTitle(self.type.rawValue)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let model: GameModel = onSave(self.snapshot)
                        self.title = model.snapshot.title
                        self.release = model.snapshot.release
                        dismiss()
                    }
                    .disabled(self.isDisabled)
                }
            }
        }
    }
}

private extension GameForm {
    
    init(_ snaphot: GameSnapshot, _ type: TypeEnum, onSave: @escaping SnapshotFunc) {
        self._title = State(wrappedValue: snaphot.title)
        self._release = State(wrappedValue: snaphot.release)
        self.onSave = onSave
        self.type = type
        self.hashValue = snaphot.hashValue
    }
    
    enum TypeEnum: Enumerable {
        case add, edit
        
        public var rawValue: String {
            switch self {
            case .add: return "Add Game"
            case .edit: return "Edit Game"
            }
        }
    }
    
    var trimmed: String {
        self.title.trimmed
    }
    
    var snapshot: GameSnapshot {
        let date: Date = .fromDate(self.release)
        return .fromView(self.trimmed, date)
    }
    
    var isDisabled: Bool {
        let isEmpty: Bool = self.trimmed.isEmpty
        let isFuture: Bool = self.release > Date.now
        let isValid: Bool = isEmpty || isFuture
        switch self.type {
        case .add:
            return isValid
        case .edit:
            let isSame: Bool = self.snapshot.hashValue == self.hashValue
            return isSame || isValid
        }
    }
    
}
