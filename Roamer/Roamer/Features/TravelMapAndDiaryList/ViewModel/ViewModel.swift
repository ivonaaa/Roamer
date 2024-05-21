//
//  ViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import Foundation
import Alamofire

@MainActor
class ViewModel: ObservableObject {
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
    
    func addCountryToMyCountries(country: String) {
        if !myCountries.contains(country) {
            myCountries.append(country)
        }
    }
}
