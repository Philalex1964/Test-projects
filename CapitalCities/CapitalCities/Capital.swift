//
//  Capital.swift
//  CapitalCities
//
//  Created by Alexander Filippov on 13.3.22..
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var url: URL
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, url: URL) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.url = url
    }

}
