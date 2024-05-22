//
//  Profile.swift
//  Roamer
//
//  Created by Ivona Perko on 21.05.2024..
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(.pink)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("Account") {
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                                .foregroundColor(.pink)
                            
                            Text("Sign out")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    })
                    
                    Button(action: {
                        Task {
                            await viewModel.deleteAccount()
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.small)
                                .font(.title)
                                .foregroundColor(.pink)
                            
                            Text("Delete account")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
