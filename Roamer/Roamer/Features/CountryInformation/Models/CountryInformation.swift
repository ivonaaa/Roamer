//
//  CountryInformation.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

struct CountryDetail: Codable, Hashable {
    let name: Name
    let continents: [String]
    let population: Int
    let capital: [String]
    let flags: Flag
}
