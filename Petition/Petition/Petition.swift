//
//  Petition.swift
//  Petition
//
//  Created by Alexander Filippov on 25.1.22..
//

import Foundation

struct Petition: Codable, Equatable {
    var title: String
    var body: String
    var signatureCount: Int
}


