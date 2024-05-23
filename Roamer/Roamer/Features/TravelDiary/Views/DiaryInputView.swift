//
//  DiaryInputView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import PhotosUI
import SwiftUI

struct DiaryInputView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: TravelDiaryViewModel
    @State private var showingImagePicker = false
    @State private var showWarrning = false
    @State private var inputImage: UIImage?
    @State var travelTitle = ""
    @State var travelDescription = ""
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                Text("Add new travel")
                    .font(.title2)
                
                HStack {
                    Button {
                        showingImagePicker = true
                    } label: {
                        VStack {
                            if let image = self.inputImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(.pink)
                            }
                        }.padding(.horizontal)
                    }.fullScreenCover(isPresented: $showingImagePicker, onDismiss: nil, content: {
                        ImagePicker(image: $inputImage)
                    })
                    Spacer()
                    
                    VStack{
                        Text("Title: ")
                        TextView(
                            text: $travelTitle
                        )
                        .padding(.horizontal, 22)
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                    }
                }
                
                Text("Description: ")
                TextView(
                    text: $travelDescription
                )
                .padding(.horizontal, 22)
                .frame(minWidth: 9, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                Spacer()
                
                Button("Save Travel") {
                    Task {
                        await viewModel.saveTravel(travelTitle: travelTitle, travelDescription: travelDescription, inputImage: inputImage ?? UIImage(), userId: user.id)
                        dismiss()
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(.pink)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}

extension DiaryInputView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return inputImage != nil
        && !travelTitle.isEmpty
        && !travelDescription.isEmpty
    }
}

#Preview {
    DiaryInputView(viewModel: TravelDiaryViewModel())
}
