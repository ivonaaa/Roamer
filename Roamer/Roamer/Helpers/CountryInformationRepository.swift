//
//  CountryInformationRepository.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import Foundation
import Alamofire

class CountryInformationRepository {
    func fetchCountries() async throws -> [CountryDetail] {
        let url = "https://restcountries.com/v3.1/all?fields=name,region,population,capital,flags"
        let dataRequest = AF
            .request(url)
            .validate()
            .serializingDecodable([CountryDetail].self)
        let result = await dataRequest.result
        
        switch result {
        case .success(let countries):
            return countries
        case .failure(let error):
            throw error
        }
    }
}

struct CountryDetail: Codable, Hashable {
    let name: Name
    let region: String
    let population: Int
    let capital: [String]
    let flags: Flag
}
