//
//  AppIcon.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public enum AppIcon: Enumerable {
    case plus
    case trash
    case pencil
    case calendar
    case chevron_right
    case chevron_up
    case chevron_down
    case checkmark
    case xmark_circle_fill
    case plus_circle_fill
    case plus_circle
    case arrow_down_circle_fill
    case opticaldisc_fill
    case person_fill
    case person_2_fill
    case person_3_fill
    case line_3_horizontal
    case ellipsis_circle
    case list_clipboard
    case list_star
    case gamecontroller
    case photo_circle_fill
    
    public var rawValue: String {
        self.id.replacingOccurrences(of: "_", with: ".")
    }
    
}
