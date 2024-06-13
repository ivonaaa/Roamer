//
//  AddCountryView.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import SwiftUI

import SwiftUI

struct AddCountryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var countriesViewModel = CountriesViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countriesViewModel.countries
        } else {
            return countriesViewModel.countries.filter { $0.officialName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationStack {
                VStack {
                    SearchBar(text: $searchText, placeholder: "Search countries")
                    
                    List(filteredCountries, id: \.self) { country in
                        Button {
                            Task {
                                await countriesViewModel.addCountryToMyCountries(country: country.countryCode, userId: user.id)
                            }
                            dismiss()
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
                                
                                Spacer()
                                
                                if countriesViewModel.myCountries.contains(country.countryCode) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    
                                    Button(action: {
                                        Task {
                                            await countriesViewModel.deleteCountryFromMyCountries(country: country.countryCode, userId: user.id)
                                        }
                                        dismiss()
                                    }, label: {
                                        Image(systemName: "trash.circle.fill")
                                            .imageScale(.large)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    })
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .padding()
                .navigationTitle("Add country")
                .onAppear {
                    Task {
                        await countriesViewModel.fetchMyCountries(userId: user.id)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: CustomBackButton())
            }
            .alert(item: $countriesViewModel.error) { error in
                Alert(title: Text(error.title), message: Text(error.description), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    AddCountryView()
}
