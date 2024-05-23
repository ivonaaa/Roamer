//
//  CountryResponse.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

struct CountryResponse: Codable {
    let name: Name
    let altSpellings: [String]
    let flags: Flag
}

struct Name: Codable, Hashable {
    let official: String
}

struct Flag: Codable, Hashable {
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
