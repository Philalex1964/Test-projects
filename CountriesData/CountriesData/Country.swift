//
//  Country.swift
//  CountriesData
//
//  Created by Alexander Filippov on 6.3.22..
//

import Foundation

struct Country: Codable {
    let name: String
    let capital: String
    let area: Int
    let population: Int
    let currency: String
}

struct Countries: Codable {
    let countries: [Country]
}
