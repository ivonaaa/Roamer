//
//  ProgressBar.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import SwiftUI

struct ProgressBar: View {
    var value: Int
    var total: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.5))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .cornerRadius(5)
                
                Rectangle()
                    .foregroundColor(.pink)
                    .frame(width: progressWidth(geometry: geometry), height: geometry.size.height)
                    .cornerRadius(5)
            }
        }
    }
    
    private func progressWidth(geometry: GeometryProxy) -> CGFloat {
        let ratio = CGFloat(value) / CGFloat(total)
        return geometry.size.width * ratio
    }
}

#Preview {
    ProgressBar(value: 5, total: 10)
}
