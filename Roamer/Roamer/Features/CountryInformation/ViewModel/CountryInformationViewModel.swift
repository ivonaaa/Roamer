//
//  CountryInformationViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import Foundation

@MainActor
class CountryInformationViewModel: ObservableObject {
    @Published var europeCountries: [CountryDetail] = []
    @Published var asiaCountries: [CountryDetail] = []
    @Published var africaCountries: [CountryDetail] = []
    @Published var northAmericaCountries: [CountryDetail] = []
    @Published var southAmericaCountries: [CountryDetail] = []
    @Published var oceaniaCountries: [CountryDetail] = []
    @Published var antarcticaCountries: [CountryDetail] = []
    @Published var error: CustomError? = nil

    
    private let countryRepository = CountryInformationRepository()

    init() {
        Task {
            await setupDataSubscription()
        }
    }

    func setupDataSubscription() async {
        do {
            let responses = try await countryRepository.fetchCountries()
            self.europeCountries = responses.filter { $0.continents[0] == "Europe" }.sorted { $0.name.common < $1.name.common }
            self.asiaCountries = responses.filter { $0.continents[0] == "Asia" }.sorted { $0.name.common < $1.name.common }
            self.africaCountries = responses.filter { $0.continents[0] == "Africa" }.sorted { $0.name.common < $1.name.common }
            self.northAmericaCountries = responses.filter { $0.continents[0] == "North America" }.sorted { $0.name.common < $1.name.common }
            self.southAmericaCountries = responses.filter { $0.continents[0] == "South America" }.sorted { $0.name.common < $1.name.common }
            self.oceaniaCountries = responses.filter { $0.continents[0] == "Oceania" }.sorted { $0.name.common < $1.name.common }
            self.antarcticaCountries = responses.filter { $0.continents[0] == "Antarctica" }.sorted { $0.name.common < $1.name.common }
        } catch {
            self.error = CustomError(title: "Failed to fetch countries information", description: "Please try again.")
            print("Error fetching countries: \(error)")
        }
    }
}
