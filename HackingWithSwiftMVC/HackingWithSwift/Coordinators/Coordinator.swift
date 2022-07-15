//
//  Coordinator.swift
//  HackingWithSwift
//
//  Created by Aleksandar Filipov on 7/15/22.
//  Copyright © 2022 Hacking with Swift. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set }
    func start()
}
