//
//  ContentView.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import SwiftUI
import InteractiveMap

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            InteractiveMap(svgName: "world-low") { pathData in // is a PathData
                InteractiveShape(pathData)
                    .stroke(self.viewModel.myCountries.contains(pathData.name) ? .pink : .gray, lineWidth: 1)
                    .background(InteractiveShape(pathData).fill(self.viewModel.myCountries.contains(pathData.name) ? .pink : .clear))
            }
            
            Text("\(viewModel.myCountries.count)/195 countries visited")
                .font(.title)
                .foregroundColor(.white)
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.pink)
                )
            
            List(viewModel.countries, id: \.self) { country in
                Button {
                    viewModel.addCountryToMyCountries(country: country.countryCode)
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: country.flag)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(20)

                        Text(country.officialName)
                        Text(country.countryCode)
                    }
                }
            }
            .listStyle(.plain)
        }.padding()
    }
}


#Preview {
    ContentView()
}
