//
//  CountryInformationViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import Foundation

@MainActor
class CountryInformationViewModel: ObservableObject {
    @Published var countries: [CountryDetail] = []
    private let countryRepository = CountryInformationRepository()

    init() {
        Task {
            await setupDataSubscription()
        }
    }

    func setupDataSubscription() async {
        do {
            let responses = try await countryRepository.fetchCountries()
            self.countries = responses
        } catch {
            print("Error fetching countries: \(error)")
        }
    }
}
