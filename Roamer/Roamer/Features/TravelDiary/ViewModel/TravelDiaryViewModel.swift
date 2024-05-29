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

    func saveTravel(travelTitle: String, travelDescription: String, inputImage: UIImage, userId: String, completion: @escaping (Bool) -> Void) async {
        guard let imageData = inputImage.jpegData(compressionQuality: 0.5) else {
            print("Image data is nil")
            completion(false)
            return
        }

        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metaData) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(false)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let downloadURL = url else {
                    print("Download URL is nil")
                    completion(false)
                    return
                }

                let travel = Travel(title: travelTitle, description: travelDescription, imageURL: downloadURL.absoluteString)

                self.saveToFirestore(travel: travel, userId: userId, completion: completion)
            }
        }
    }

    private func saveToFirestore(travel: Travel, userId: String, completion: @escaping (Bool) -> Void) {
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
                completion(false)
            } else {
                print("Travel saved successfully")
                completion(true)
            }
        }
    }

    func editTravel(oldTitle: String, newTitle: String, newDescription: String, newImage: UIImage?, userId: String, completion: @escaping (Bool) -> Void) async {
        await fetchTravels(userId: userId)

        guard let travelIndex = travels.firstIndex(where: { $0.title == oldTitle }) else {
            print("Travel not found")
            completion(false)
            return
        }

        var travel = travels[travelIndex]

        travel.title = newTitle
        travel.description = newDescription

        if let newImage = newImage {
            guard let imageData = newImage.jpegData(compressionQuality: 0.5) else {
                print("Image data is nil")
                completion(false)
                return
            }

            let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"

            storageRef.putData(imageData, metadata: metaData) { _, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error retrieving download URL: \(error.localizedDescription)")
                        completion(false)
                        return
                    }

                    guard let downloadURL = url else {
                        print("Download URL is nil")
                        completion(false)
                        return
                    }

                    travel.imageURL = downloadURL.absoluteString

                    self.saveToFirestoreAfterEdit(travel: travel, userId: userId, oldTitle: oldTitle, completion: completion)
                }
            }
        } else {
            self.saveToFirestoreAfterEdit(travel: travel, userId: userId, oldTitle: oldTitle, completion: completion)
        }
    }

    private func saveToFirestoreAfterEdit(travel: Travel, userId: String, oldTitle: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let travelsRef = db.collection("travels").document(userId)

        travelsRef.getDocument { document, error in
            if let document = document, document.exists {
                var travelsData = document.data()?["travels"] as? [[String: Any]] ?? []

                if let index = travelsData.firstIndex(where: { $0["title"] as? String == oldTitle }) {
                    travelsData[index] = [
                        "title": travel.title,
                        "description": travel.description,
                        "imageURL": travel.imageURL
                    ]

                    travelsRef.updateData(["travels": travelsData]) { error in
                        if let error = error {
                            print("Error updating travel: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Travel updated successfully")
                            completion(true)
                        }
                    }
                } else {
                    print("Travel not found in Firestore data")
                    completion(false)
                }
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }

    func deleteTravel(travelTitle: String, userId: String, completion: @escaping (Bool) -> Void) async {
        await fetchTravels(userId: userId)

        guard let travel = travels.first(where: { $0.title == travelTitle }) else {
            print("Travel not found")
            completion(false)
            return
        }

        let storageRef = Storage.storage().reference(forURL: travel.imageURL)
        storageRef.delete { error in
            if let error = error {
                print("Error deleting image: \(error.localizedDescription)")
                completion(false)
                return
            }

            let travelsRef = Firestore.firestore().collection("travels").document(userId)
            travelsRef.getDocument { document, error in
                if let document = document, document.exists {
                    var travelsData = document.data()?["travels"] as? [[String: Any]] ?? []

                    if let index = travelsData.firstIndex(where: { $0["title"] as? String == travelTitle }) {
                        travelsData.remove(at: index)

                        travelsRef.updateData(["travels": travelsData]) { error in
                            if let error = error {
                                print("Error deleting travel from Firestore: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Travel deleted successfully")
                                completion(true)
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                    completion(false)
                }
            }
        }
    }
}
