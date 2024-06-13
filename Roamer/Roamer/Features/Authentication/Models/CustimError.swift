//
//  CustimError.swift
//  Roamer
//
//  Created by Ivona Perko on 13.06.2024..
//

import Foundation

struct CustomError: Identifiable {
    var id = UUID()
    var title: String
    var description: String
}
