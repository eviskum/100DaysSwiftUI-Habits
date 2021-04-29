//
//  HabitsApp.swift
//  Habits
//
//  Created by Esben Viskum on 28/04/2021.
//

import SwiftUI

@main
struct HabitsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Habits())
        }
    }
}
