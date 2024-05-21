//
//  ContentView.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import SwiftUI
import InteractiveMap

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TravelMapAndDiaryView()
            } else {
                LoginView()
            }
        }
    }
}


#Preview {
    ContentView()
}
