//
//  ConutryInformationList.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import SwiftUI

struct ConutryInformationList: View {
    @ObservedObject var countriesViewModel = CountryInformationViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 20) {
                ForEach(countriesViewModel.countries, id: \.self) { country in
                    CountryDetailView(country: country)
                }
            }
            .padding()
        }
        .frame(height: 220)
    }
}

struct CountryDetailView: View {
    let country: CountryDetail
    
    var body: some View {
        VStack {
            Text(country.name.official)
                .font(.headline)
            Text("Region: \(country.region)")
            Text("Population: \(country.population)")
            Text("Capital: \(country.capital.joined(separator: ", "))")
            // You can add more details here as needed
            
            Spacer()
            
            Image(systemName: "flag")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.top, 20)
        }
        .frame(width: 200, height: 200)
        .background(Color.blue)
        .cornerRadius(10)
    }
}

struct ConutryInformationList_Previews: PreviewProvider {
    static var previews: some View {
        ConutryInformationList()
    }
}
