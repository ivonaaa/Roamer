//
//  CountryRepository.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import Alamofire

class CountryRepository {
    func fetchCountries() async throws -> [CountryResponse] {
        let url = "https://restcountries.com/v3.1/all?fields=name,flags,altSpellings"
        let dataRequest = AF.request(url).validate().serializingDecodable([CountryResponse].self)
        let result = await dataRequest.result
        
        switch result {
        case .success(let countries):
            return countries
        case .failure(let error):
            throw error
        }
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
