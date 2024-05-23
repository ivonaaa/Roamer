//
//  TravelRowView.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import SwiftUI

struct TravelRowView: View {
    let travel: Travel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: travel.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 70)
            .cornerRadius(35)
            
            Text(travel.title)
                .font(.title2)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fontDesign(.serif)
        }
        .frame(width: UIScreen.main.bounds.width - 30 , height: 80)
    }
}

#Preview {
    TravelRowView(travel: Travel(title: "title", description: "", imageURL: ""))
}
