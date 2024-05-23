//
//  CountryDetailView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import SwiftUI

struct CountryDetailView: View {
    let country: CountryDetail
    @StateObject private var geocodingViewModel = GeocodingViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(country.name.common)
                .font(.largeTitle)
                .fontDesign(.serif)
            
            if let coordinate = geocodingViewModel.coordinate {
                MapView(coordinate: coordinate)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                    .cornerRadius(10)
                    .padding(.vertical, 20)
            } else {
                ProgressView()
                    .frame(height: 200)
            }
            
            VStack(alignment: .center, spacing: 20) {
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        AsyncImage(url: URL(string: country.flags.png)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 20)
                                    .clipShape(Rectangle())
                            } else {
                                ProgressView()
                                    .frame(width: 30, height: 20)
                                    .clipShape(Rectangle())
                            }
                        }
                    
                        Text("flag")
                            .font(.footnote)
                    }
                    Spacer()
                    VStack {
                        Text(String(country.population))
                            .font(.title2)
                            .font(.system(size: 20))
                            .bold()
                        Text("population")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 20)
                .padding(.vertical)
                .background(Color.pink.opacity(0.2))
                .cornerRadius(10)
                
                VStack {
                    Text(country.continents[0])
                        .font(.title2)
                        .font(.system(size: 20))
                        .bold()
                    Text("continent")
                        .font(.footnote)
                }
                .frame(width: UIScreen.main.bounds.width - 20)
                .padding(.vertical)
                .background(Color.pink.opacity(0.2))
                .cornerRadius(10)
                
                if !country.capital.isEmpty {
                    VStack {
                        Text(country.capital[0])
                            .font(.title)
                            .bold()
                        Text("capital")
                            .font(.footnote)
                    }
                    .frame(width: UIScreen.main.bounds.width - 20)
                    .padding(.vertical)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            if !country.capital.isEmpty {
                geocodingViewModel.geocode(address: country.capital[0])
            } else {
                geocodingViewModel.geocode(address: country.name.common)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}
