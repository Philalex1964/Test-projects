//
//  Person.swift
//  NamesToFaces
//
//  Created by Alexander Filippov on 3.2.22..
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    
}
