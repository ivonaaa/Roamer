//
//  ViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import Foundation
import Alamofire
import Combine

class ViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var myCountries: [String] = []
    private var cancellables = Set<AnyCancellable>()
    private let countryRepository = CountryRepository()

    init() {
        setupDataSubscription()
    }

    func setupDataSubscription() {
        countryRepository.fetchCountries()
            .map { responses in
                responses.map { country in
                    Country(
                        officialName: country.name.official,
                        countryCode: country.altSpellings.first ?? "",
                        flag: country.flags.png
                    )
                }
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("Error fetching countries: \(error)")
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries
            }
            .store(in: &cancellables)
    }
    
    func addCountryToMyCountries(country: String) {
        if !myCountries.contains(country) {
            myCountries.append(country)
        }
    }
}
