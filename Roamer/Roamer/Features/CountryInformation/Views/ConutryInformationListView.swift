//
//  ConutryInformationList.swift
//  Roamer
//
//  Created by Ivona Perko on 22.05.2024..
//

import SwiftUI

struct ConutryInformationListView: View {
    @ObservedObject var countriesViewModel = CountryInformationViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                RegionScrollView(regionName: "Europe", countries: countriesViewModel.europeCountries)
                RegionScrollView(regionName: "Asia", countries: countriesViewModel.asiaCountries)
                RegionScrollView(regionName: "Africa", countries: countriesViewModel.africaCountries)
                RegionScrollView(regionName: "North America", countries: countriesViewModel.northAmericaCountries)
                RegionScrollView(regionName: "South America", countries: countriesViewModel.southAmericaCountries)
                RegionScrollView(regionName: "Oceania", countries: countriesViewModel.oceaniaCountries)
                RegionScrollView(regionName: "Antarctica", countries: countriesViewModel.antarcticaCountries)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
        }
    }
}

struct ConutryInformationList_Previews: PreviewProvider {
    static var previews: some View {
        ConutryInformationListView()
    }
}
