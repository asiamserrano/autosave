//
//  AppRouter.swift
//  autosave
//
//  Created by Asia Serrano on 9/1/25.
//
//  PURPOSE:
//  --------
//  AppRouter is responsible for navigation flow.
//  - Think of it as the "map" or "GPS" of the app.
//  - Keeps track of *where the user is going* by managing navigation paths and destinations.
//
//  WHEN TO USE:
//  ------------
//  - If you use NavigationStack, Router owns the "path" array.
//  - Centralize navigation logic instead of letting each feature decide on its own.
//  - Define Routes (like .login, .gameDetail(id)) so you can push/pop screens programmatically.
//
//  IMPORTANT:
//  ----------
//  - Router should not store data (leave that to AppState or feature view models).
//  - Keep routes lightweight and focused on navigation only.
//

import Foundation
