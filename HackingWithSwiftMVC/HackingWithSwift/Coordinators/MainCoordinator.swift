//
//  MainCoordinator.swift
//  HackingWithSwift
//
//  Created by Aleksandar Filipov on 7/15/22.
//  Copyright © 2022 Hacking with Swift. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
    
    
}
