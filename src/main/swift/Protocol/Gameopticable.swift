//
//  Gameopticable.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

import Foundation
import SwiftUI
import PhotosUI
import SwiftData

public protocol Gameopticable: View {
    var builder: GameBuilder { get }
}

public extension Gameopticable {
    
    var title: String {
        self.builder.title
    }
    
    var release: Date {
        self.builder.release
    }

    var status: GameStatusEnum {
        self.builder.status
    }
    
    var boxart: Data? {
        self.builder.boxart
    }
    
    var tags: Tags {
        self.builder.tags
    }
    
    var editMode: EditMode {
        self.builder.editMode
    }
    
//    var photosPickerItem: PhotosPickerItem? {
//        self.builder.photosPickerItem
//    }
//    
//    var imagePicker: ImagePickerEnum {
//        self.builder.imagePicker
//    }
    
    var isLibrary: Bool {
        self.status == .library
    }
    
    var isBoxartEmpty: Bool {
        self.boxart == nil
    }
    
    var isBoxartNotEmpty: Bool {
        self.boxart != nil
    }
    
    var isEditing: Bool {
        self.editMode == .active
    }
    
    var topBarTrailingButton: ConstantEnum {
        self.isEditing ? .done : .edit
    }
    
    var tagType: TagType {
        self.builder.tagType
    }
    
    
//    var isBackButtonHidden: Bool { self.builder.isNew ? false : self.isEditing }
//    var isConfirmButtonDisabled: Bool { self.isEditing ? self.builder.isDisabled : false }
 
    func setBoxart(_ data: Data?) -> Void {
        self.builder.boxart = data
    }
    
    func setEditMode(_ mode: EditMode) -> Void {
        self.builder.editMode = mode
    }
    
    func toggleEditMode() -> Void {
        let mode: EditMode = self.editMode.toggle
        self.setEditMode(mode)
    }
    
    func delete(_ builder: Tags.Builder) -> Void {
        self.builder.tags.delete(builder)
    }
    
    
    
//    func setData(_ data: Data?, _ picker: ImagePickerEnum) -> Void {
//        withAnimation {
//            self.builder.boxart = data
//            self.setPicker(picker)
//        }
//    }
    
//    func setPicker(_ picker: ImagePickerEnum) -> Void {
//        self.builder.imagePicker = picker
//    }
//    
//    func resetPhotosPickerItem() -> Void {
//        self.builder.photosPickerItem = nil
//    }
    
//    var propertyEnum: PropertyEnum { self.observer.propertyEnum }
//    var properties: PropertyBuilderGroup { self.observer.properties }

}
