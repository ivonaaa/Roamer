//
//  CountriesViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import Foundation
import Alamofire
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CountriesViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var myCountries: [String] = []
    private let countryRepository = CountryRepository()
    @Published var error: CustomError? = nil

    init() {
        Task {
            await setupDataSubscription()
        }
    }

    func setupDataSubscription() async {
        do {
            error = nil
            let responses = try await countryRepository.fetchCountries()
            self.countries = responses.map { country in
                Country(
                    officialName: country.name.common,
                    countryCode: country.altSpellings.first ?? "",
                    flag: country.flags.png
                )
            }
            self.countries = self.countries.sorted { $0.officialName < $1.officialName }
        } catch {
            self.error = CustomError(title: "Failed to fetch countries", description: "Please try again.")
            print("Error fetching countries: \(error)")
        }
    }
    
    func fetchMyCountries(userId: String) async {
        do {
            error = nil
            let document = try await Firestore.firestore().collection("countries").document(userId).getDocument()
            if let data = document.data(), let countries = data["myCountries"] as? [String] {
                self.myCountries = countries
            }
        } catch {
            self.error = CustomError(title: "Failed to fetch countries", description: "Please try again.")
            print("Error fetching user countries: \(error)")
        }
    }
    
    func addCountryToMyCountries(country: String, userId: String) async {
        guard !myCountries.contains(country) else { return }
        myCountries.append(country)
        
        do {
            error = nil
            try await Firestore.firestore().collection("countries").document(userId).setData(["myCountries": myCountries], merge: true)
        } catch {
            self.error = CustomError(title: "Failed to add country", description: "Please try again.")
            print("Failed to update user's countries: \(error)")
        }
    }
    
    func deleteCountryFromMyCountries(country: String, userId: String) async {
        guard let index = myCountries.firstIndex(of: country) else { return }
        myCountries.remove(at: index)
        
        do {
            error = nil
            try await Firestore.firestore().collection("countries").document(userId).setData(["myCountries": myCountries], merge: true)
        } catch {
            self.error = CustomError(title: "Failed to delete country", description: "Please try again.")
            print("Failed to update user's countries: \(error)")
        }
    }

}
