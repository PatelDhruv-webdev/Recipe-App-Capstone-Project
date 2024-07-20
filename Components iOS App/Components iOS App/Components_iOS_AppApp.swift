//
//  Components_iOS_AppApp.swift
//  Components iOS App
//
//  Created by Dhruv Patel on 19/07/24.
//

import SwiftUI

@main
struct Components_iOS_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
