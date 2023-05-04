//
//  Next_ActApp.swift
//  Next Act
//
//  Created by Michael Frisk on 2023-05-04.
//

import SwiftUI

@main
struct Next_ActApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
