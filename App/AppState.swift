//
//  AppState.swift
//  autosave
//
//  Created by Asia Serrano on 9/1/25.
//
//  PURPOSE:
//  --------
//  AppState is the "global data store" for the app.
//  - Holds simple, high-level facts about the app that multiple features might need.
//  - Keeps track of *what the app IS*, not where the user is going.
//
//  WHEN TO USE:
//  ------------
//  - Store flags like "isLoggedIn", "hasCompletedOnboarding", or "isOfflineMode".
//  - Store global settings like theme overrides (light/dark).
//  - Store app-wide notifications or alerts to display.
//
//  IMPORTANT:
//  ----------
//  - Keep AppState small — don’t turn it into a giant container for every piece of data.
//  - Feature-specific state (like "which tab is open in Library") should live inside that feature.
//

import Foundation
