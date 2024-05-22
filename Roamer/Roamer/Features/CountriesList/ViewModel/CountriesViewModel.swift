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

    init() {
        Task {
            await setupDataSubscription()
        }
    }

    func setupDataSubscription() async {
        do {
            let responses = try await countryRepository.fetchCountries()
            self.countries = responses.map { country in
                Country(
                    officialName: country.name.official,
                    countryCode: country.altSpellings.first ?? "",
                    flag: country.flags.png
                )
            }
        } catch {
            print("Error fetching countries: \(error)")
        }
    }
    
    func fetchMyCountries(userId: String) async {
        do {
            let document = try await Firestore.firestore().collection("countries").document(userId).getDocument()
            if let data = document.data(), let countries = data["myCountries"] as? [String] {
                self.myCountries = countries
            }
        } catch {
            print("Error fetching user countries: \(error)")
        }
    }
    
    func addCountryToMyCountries(country: String, userId: String) async {
        guard !myCountries.contains(country) else { return }
        myCountries.append(country)
        
        do {
            try await Firestore.firestore().collection("countries").document(userId).setData(["myCountries": myCountries], merge: true)
        } catch {
            print("Failed to update user's countries: \(error)")
        }
    }
}
