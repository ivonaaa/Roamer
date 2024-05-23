//
//  TravelListView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//
import SwiftUI

struct TravelListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = TravelDiaryViewModel()
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(alignment: .center) {
                List(viewModel.travels, id: \.self) { travel in
                    NavigationLink(destination: TravelDetailView(viewModel: viewModel, travel: travel)) {
                        TravelRowView(travel: travel)
                            .padding(.bottom, 0) // Set bottom padding to zero to remove the separator line
                    }
                    .frame(width: UIScreen.main.bounds.width-30 , height: 80)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(10)
                }
                .listStyle(InsetListStyle())
            }
            .navigationBarTitle("Travels")
            .navigationBarItems(
                trailing: HStack {
                    NavigationLink(destination: DiaryInputView(viewModel: viewModel)) {
                        Label("Add travel", systemImage: "plus")
                            .foregroundColor(.pink)
                    }
                }
            )
            .refreshable {
                Task {
                    await viewModel.fetchTravels(userId: user.id)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchTravels(userId: user.id)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
        }
    }
}


#Preview {
    TravelListView()
}
