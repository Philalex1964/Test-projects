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
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func show(_ project: Project) {
        let detailVC = DetailViewController.instantiate()
        detailVC.project = project
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func read(_ project: Project) {
        let readVC = ReadViewController.instantiate()
        readVC.project = project
        
        navigationController.pushViewController(readVC, animated: true)
    }
}
