//
//  Picture.swift
//  StormViewer
//
//  Created by Alexander Filippov on 7.2.22..
//

import UIKit

class Picture: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
