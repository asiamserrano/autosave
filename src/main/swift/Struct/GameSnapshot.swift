//
//  GameSnapshot.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public struct GameSnapshot: Uuidentifiable {
    
    public static func defaultValue(_ status: GameStatusEnum) -> Self {
        .init(.init(), .defaultValue, .defaultValue, status, nil)
    }
    
    public static func random(_ status: GameStatusEnum) -> Self {
        .init(.init(), .random, .random, status, nil)
    }
    
    public static var random: Self {
        .random(.random)
    }
    
    public static func fromView(_ title: String, _ release: Date) -> Self {
        .init(.init(), title, release, .defaultValue, nil)
    }
    
    public static func fromModel(_ model: GameModel) -> Self {
        let release: Date = .fromString(model.release_date)
        let status: GameStatusEnum = .fromBool(model.status_bool)
        return .init(model.uuid, model.title_trim, release, status, model.boxart_data)
    }
    
    public static func fromBuilder(_ builder: GameBuilder) -> Self {
        let uuid: UUID = builder.uuid
        let title: String = builder.title.trimmed
        let release: Date = builder.release
        let status: GameStatusEnum = builder.status
        let boxart: Data? = builder.boxart
        return .init(uuid, title, release, status, boxart)
    }
    
    public let uuid: UUID
    public let title: String
    public let release: Date
    public let status: GameStatusEnum
    public let boxart: Data?
    
    private init(_ u: UUID, _ t: String, _ r: Date, _ s: GameStatusEnum, _ b: Data?) {
        self.uuid = u
        self.title = t
        self.release = r
        self.status = s
        self.boxart = b
    }
    
    public var title_canon: String {
        title.canonicalized
    }
    
    public var title_trim: String {
        title.trimmed
    }
    
    public var release_date: String {
        release.dashless
    }
    
    public var status_bool: Bool {
        self.status.bool
    }
    
    public var display: String {
        "\(self.title) (\(self.release.year))"
    }

}

extension GameSnapshot: Stable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.title_trim)
        hasher.combine(self.release_date)
        hasher.combine(self.status)
        hasher.combine(self.boxart)
    }
    
}

extension GameSnapshot: Comparable {
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        if lhs.title_canon == rhs.title_canon {
            return lhs.release_date < rhs.release_date
        } else {
            return lhs.title_canon < rhs.title_canon
        }
    }
    
}
