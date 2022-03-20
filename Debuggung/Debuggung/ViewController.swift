//
//  ViewController.swift
//  Debuggung
//
//  Created by Alexander Filippov on 20.3.22..
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I'm inside the viewDidLoad() method!")
        
        print(1, 2, 3, 4, 5)
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")

    }


}

