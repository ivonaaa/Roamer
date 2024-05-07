//
//  CountryRepository.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import Alamofire
import Combine

class CountryRepository {
    func fetchCountries() -> AnyPublisher<[CountryResponse], AFError> {
        let url = "https://restcountries.com/v3.1/all?fields=name,flags,altSpellings"
        return AF.request(url)
            .validate()
            .publishDecodable(type: [CountryResponse].self)
            .value()
            .eraseToAnyPublisher()
    }
}

struct CountryResponse: Codable {
    let name: Name
    let altSpellings: [String]
    let flags: Flag
}

struct Name: Codable {
    let official: String
}

struct Flag: Codable {
    let png: String
}

struct Country: Hashable {
    let officialName: String
    let countryCode: String
    let flag: String
    
    init(officialName: String, countryCode: String, flag: String) {
        self.officialName = officialName
        self.countryCode = countryCode
        self.flag = flag
    }
}
