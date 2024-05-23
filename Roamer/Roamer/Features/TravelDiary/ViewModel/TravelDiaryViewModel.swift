//
//  TravelViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor
class TravelDiaryViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var travels: [Travel] = []
    
    func fetchTravels(userId: String) async {
        do {
            self.travels = []
            let document = try await Firestore.firestore().collection("travels").document(userId).getDocument()
            if let data = document.data(), let travelsData = data["travels"] as? [[String: Any]] {
                for travel in travelsData {
                    guard let title = travel["title"] as? String,
                          let description = travel["description"] as? String,
                          let imageURL = travel["imageURL"] as? String else {
                        return
                    }
                    self.travels.append(Travel(title: title, description: description, imageURL: imageURL))
                }
            }
        } catch {
            print("Error fetching user travels: \(error)")
        }
    }

    
    func saveTravel(travelTitle: String, travelDescription: String, inputImage: UIImage, userId: String) async {
        guard let imageData = inputImage.jpegData(compressionQuality: 0.5) else {
            print("Image data is nil")
            return
        }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metaData) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    print("Download URL is nil")
                    return
                }
                
                let travel = Travel(title: travelTitle, description: travelDescription, imageURL: downloadURL.absoluteString)
                
                self.saveToFirestore(travel: travel, userId: userId)
            }
        }
    }
        
    private func saveToFirestore(travel: Travel, userId: String) {
        let db = Firestore.firestore()
        let travelsRef = db.collection("travels")
        let travelData: [String: Any] = [
            "title": travel.title,
            "description": travel.description,
            "imageURL": travel.imageURL
        ]
        
        travelsRef.document(userId).setData(["travels": FieldValue.arrayUnion([travelData])], merge: true) { error in
            if let error = error {
                print("Error saving travel to Firestore: \(error.localizedDescription)")
            } else {
                print("Travel saved successfully")
            }
        }
    }
}
