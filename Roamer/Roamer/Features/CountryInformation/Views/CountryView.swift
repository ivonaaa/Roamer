//
//  CountryView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import SwiftUI

struct CountryView: View {
    let country: CountryDetail
    
    var body: some View {
        NavigationLink(destination: CountryDetailView(country: country)) {
            VStack {
                AsyncImage(url: URL(string: country.flags.png)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Color.red // Indicates an error
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    } else {
                        ProgressView()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 10)
                
                Text(country.name.common)
                    .font(.footnote)
                    .foregroundColor(.gray) // Ensure contrast with the background color
                    .padding(.bottom, 10)
            }
            .multilineTextAlignment(.center)
            .frame(width: 100, height: 100)
        }
    }
}
