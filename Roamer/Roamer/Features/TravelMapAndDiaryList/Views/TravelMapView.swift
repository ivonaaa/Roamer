//
//  TravelMapAndDiaryView.swift
//  Roamer
//
//  Created by Ivona Perko on 11.05.2024..
//

import SwiftUI
import InteractiveMap

struct TravelMapView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var travelViewModel = TravelViewModel()

    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack {
                    Divider()
                    
                    InteractiveMap(svgName: "world-low") { pathData in
                        InteractiveShape(pathData)
                            .stroke(.gray)
                            .background(InteractiveShape(pathData).fill(self.travelViewModel.myCountries.contains(pathData.name) ? .pink : Color.pink.opacity(0.15)))
                    }
                    .padding(.vertical)
                    .frame(height: 250)
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack {
                        ProgressBar(value: travelViewModel.myCountries.count, total: 195)
                                                .frame(height: 10)
                                                .padding(.horizontal)
                        
                        HStack {
                            VStack {
                                Text("\(Int(travelViewModel.myCountries.count * 100 / 195))%")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.pink)
                                
                                Text("world")
                                    .font(.footnote)
                            }
                            .padding(.leading, 50)
                            
                            Spacer()
                            
                            VStack {
                                Text("\(travelViewModel.myCountries.count)")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.pink)
                                
                                Text("countries")
                                    .font(.footnote)
                            }
                            .padding(.trailing, 50)
                        }
                        .padding(.vertical)
                        
                        Text("Out of 195 UN countries")
                            .font(.footnote)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.pink.opacity(0.3))
                    )
                    .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 10)
                    .padding(.top, 30)
                    
                    Spacer()
                }
                .padding()
                .navigationBarItems(
                    leading: HStack {
                        Image("icon") 
                            .renderingMode(.template)
                            .font(.footnote)
                            .foregroundColor(.pink)
                            .padding(.vertical)
                        
                        Text("roamer")
                            .font(.largeTitle)
                            .foregroundStyle(.pink)
                            .padding(.vertical)
                    },
                    trailing: HStack {
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person")
                                .font(.title2)
                                .foregroundColor(.pink)
                                .padding(.vertical)
                        }
                        Menu {
                            NavigationLink(destination: TravelListView()) {
                                Label("My travels", systemImage: "mappin.and.ellipse")
                            }
                            NavigationLink(destination: AddCountryView()) {
                                Label("My countries", systemImage: "map")
                            }
                            NavigationLink(destination: ConutryInformationListView()) {
                                Label("Explore countries", systemImage: "lightbulb")
                            }
                        } label: {
                            Label("", systemImage: "ellipsis.circle")
                                .font(.title2)
                                .foregroundColor(.pink)
                                .padding(.vertical)
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
    TravelMapView()
}
