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
        let url = "https://restcountries.com/v3.1/all?fields=name,continents,population,capital,flags"
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
