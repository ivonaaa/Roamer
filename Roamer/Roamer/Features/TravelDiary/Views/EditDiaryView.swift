//
//  EditDiaryView.swift
//  Roamer
//
//  Created by Ivona Perko on 29.05.2024..
//

import PhotosUI
import SwiftUI

struct EditDiaryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: TravelDiaryViewModel
    @Binding var travel: Travel
    
    @State private var showingImagePicker = false
    @State private var showCamera = false
    
    @State private var inputImage: UIImage?
    @State var travelTitle: String
    @State var travelDescription: String
    
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: TravelDiaryViewModel, travel: Binding<Travel>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._travel = travel
        self._travelTitle = State(initialValue: travel.wrappedValue.title)
        self._travelDescription = State(initialValue: travel.wrappedValue.description)
    }
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                Text("Edit Travel")
                    .font(.title2)
                
                HStack {
                    Menu {
                        Button {
                            showCamera.toggle()
                        } label: {
                            Label("Take photo", systemImage: "camera")
                        }
                        Button {
                            showingImagePicker.toggle()
                        } label: {
                            Label("Choose from gallery", systemImage: "photo")
                        }
                    } label: {
                        VStack {
                            if let image = self.inputImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            } else {
                                AsyncImage(url: URL(string: travel.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                }
                            }
                        }.padding(.horizontal)
                    }
                    .fullScreenCover(isPresented: $showingImagePicker, onDismiss: nil, content: {
                        ImagePicker(image: $inputImage)
                    })
                    .fullScreenCover(isPresented: self.$showCamera, onDismiss: nil, content: {
                        accessCameraView(selectedImage: self.$inputImage)
                    })
                    
                    Spacer()
                    
                    VStack {
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
                
                Button("Save Changes") {
                    Task {
                        await viewModel.editTravel(oldTitle: travel.title, newTitle: travelTitle, newDescription: travelDescription, newImage: inputImage, userId: user.id) { success in
                            if success {
                                travel.title = travelTitle
                                travel.description = travelDescription
                                if let newImageURL = inputImage {
                                    travel.imageURL = newImageURL.description
                                }
                                dismiss()
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                .background(.pink)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .foregroundColor(.white)
                .cornerRadius(10)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: CustomBackButton())
            }
        }
    }
}

extension EditDiaryView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !travelTitle.isEmpty && !travelDescription.isEmpty
    }
}

#Preview {
    EditDiaryView(viewModel: TravelDiaryViewModel(), travel: .constant(Travel(title: "Title", description: "Description", imageURL: "")))
}
