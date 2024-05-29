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
    @State private var showSplashScreen = true
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}


struct SplashScreenView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome!")
                .font(.largeTitle)
                .foregroundStyle(.pink)
                .padding(.vertical)
            
            ProgressView()
            
            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .padding(.top, 36)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashScreenView()
}
