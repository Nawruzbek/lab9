//
//  FoodDeliveryAppApp.swift
//  FoodDeliveryApp
//
//  Created by Nawruzbek Ibragimow on 24.05.2026.
//

import SwiftUI
import CoreData

@main
struct FoodDeliveryAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
