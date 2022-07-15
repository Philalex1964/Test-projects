//
//  Storyboarded.swift
//  HackingWithSwift
//
//  Created by Aleksandar Filipov on 7/15/22.
//  Copyright © 2022 Hacking with Swift. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
