//
//  RegionScrollView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import SwiftUI

struct RegionScrollView: View {
    let regionName: String
    let countries: [CountryDetail]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(regionName)
                    .padding(.leading)
                    .font(.title2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(countries, id: \.self) { country in
                            CountryView(country: country)
                        }
                    }
                    .padding()
                }
                Divider()
            }
        }
    }
}
