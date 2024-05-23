//
//  TravelMapAndDiaryView.swift
//  Roamer
//
//  Created by Ivona Perko on 11.05.2024..
//

import SwiftUI
import InteractiveMap

struct TravelMapAndDiaryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var travelViewModel = TravelViewModel()

    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack {
                    InteractiveMap(svgName: "world-low") { pathData in
                        InteractiveShape(pathData)
                            .stroke(self.travelViewModel.myCountries.contains(pathData.name) ? .pink : .gray, lineWidth: 1)
                            .background(InteractiveShape(pathData).fill(self.travelViewModel.myCountries.contains(pathData.name) ? .pink : .clear))
                    }
                    .frame(height: 250)
                    
                    VStack {
                        HStack {
                            VStack {
                                Text("\(Int(travelViewModel.myCountries.count * 100 / 195))%")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("world")
                                    .font(.footnote)
                            }
                            .padding(.leading, 50)
                            
                            Spacer()
                            
                            VStack {
                                Text("\(travelViewModel.myCountries.count)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("countries")
                                    .font(.footnote)
                            }
                            .padding(.trailing, 50)
                        }
                        Text("Out of 195 UN countries")
                            .font(.footnote)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.pink)
                    )
                    
                    Spacer()
                }
                .padding()
                .navigationBarItems(
                    leading: HStack {
                        Text("Icon")
                        Text("roamer")
                            .font(.title)
                            .foregroundStyle(.pink)
                    },
                    trailing: HStack {
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person")
                                .foregroundColor(.pink)
                        }
                        Menu {
                            NavigationLink(destination: EmptyView()) {
                                Label("Add travel", systemImage: "plus")
                            }
                            NavigationLink(destination: AddCountryView()) {
                                Label("Add country", systemImage: "map")
                            }
                            NavigationLink(destination: ConutryInformationList()) {
                                Label("Explore countries", systemImage: "lightbulb")
                            }
                        } label: {
                            Label("", systemImage: "ellipsis.circle")
                                .foregroundColor(.pink)
                        }
                    }
                )
                .onAppear {
                    Task {
                        await travelViewModel.fetchMyCountries(userId: user.id)
                    }
                }
            }
        }
    }
}

#Preview {
    TravelMapAndDiaryView()
}
