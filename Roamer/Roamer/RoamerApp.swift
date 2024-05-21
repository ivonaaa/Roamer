//
//  RoamerApp.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import SwiftUI
import Firebase

@main
struct RoamerApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
