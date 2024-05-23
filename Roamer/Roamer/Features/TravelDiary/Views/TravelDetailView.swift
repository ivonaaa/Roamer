//
//  TravelDetailView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import SwiftUI

struct TravelDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel: TravelDiaryViewModel
    let travel: Travel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(travel.title)
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                        .fontDesign(.serif)
                    
                    AsyncImage(url: URL(string: travel.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20)
                    .cornerRadius(20)
                    
                    Text(travel.description)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                .padding()
            }
        }
    }
}


#Preview {
    TravelDetailView(viewModel: TravelDiaryViewModel(), travel: Travel(title: "Title", description: "Description", imageURL: ""))
}
