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
                    
                    Text("\(travelViewModel.myCountries.count)/195 countries visited")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical, 40)
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
                            NavigationLink(destination: EmptyView()) {
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
