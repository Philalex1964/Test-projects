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
        
        assert(1 == 1, "Maths failure1!")
//        assert(1 == 2, "Maths failure2!")
        
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing!")

    }
    
    func myReallySlowMethod() -> Bool {
        return false
    }


}

