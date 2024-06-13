//
//  AuthViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 21.05.2024..
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var error: CustomError? = nil
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            error = nil
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            self.error = CustomError(title: "Failed to sign in user", description: "Please try again.")
            print("failed to sign in user")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            error = nil
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user) 
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            self.error = CustomError(title: "Failed to create user", description: "Please try again.")
            print("failed to create user")
        }
    }
    
    func signOut() {
        do {
            error = nil
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            self.error = CustomError(title: "Failed to sign out user", description: "Please try again.")
            print("failed to sigh out")
        }
    }
    
    func fetchUser() async {
        error = nil
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            error = nil
            try await Firestore.firestore().collection("users").document(user.uid).delete()
            try await Firestore.firestore().collection("travels").document(user.uid).delete()
            try await Firestore.firestore().collection("countries").document(user.uid).delete()
            try await user.delete()
            
            self.userSession = nil
            self.currentUser = nil
        } catch {
            self.error = CustomError(title: "Failed to delete account", description: "Please try again.")
            print("Failed to delete account \(error)")
        }
    }
}
