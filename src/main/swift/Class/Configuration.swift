//
//  Configuration.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

public class Configuration: ObservableObject {
    
    public static var defaultValue: Configuration { .init() }

    @Published public private(set) var alertEnum: AlertEnum = .none
    @Published public private(set) var gameSortEnum: GameSortEnum = .title(.forward)

    public private(set) var menuEnum: MenuEnum = .library
//    public private(set) var gameStatusEnum: GameStatusEnum = .library

    private init() { }
    
}

public extension Configuration {
    
//    var menuEnumBinding: Binding<MenuEnum> {
//        .init(get: {
//            self.menuEnum
//        }, set: { newValue in
//            self.menuEnum = newValue
//            if let cast: GameStatusEnum = .cast(newValue) {
//                self.gameStatusEnum = cast
//            }
//        })
//    }
//
    
    var gameStatusEnum: GameStatusEnum {
        self.menuEnum == .wishlist ? .wishlist : .library
    }
    
//    func setAlertEnum() {
//        self.alertEnum = .none
//    }
//
//    func setAlertEnum(_ result: GameResult? = nil) {
//        self.alertEnum = result.alert
//    }
    
//    func setGameModel(_ model: GameModel? = nil) {
//        self.gameModel = model
//    }
//
//    func setTagModel(_ model: TagModel? = nil) {
//        self.tagModel = model
//    }
//
//    func setMenuEnum(_ menu: MenuEnum) -> Void {
//        self.menuEnum = menu
//        self.gameSortEnum = .title(true)
//    }
//

    
}
