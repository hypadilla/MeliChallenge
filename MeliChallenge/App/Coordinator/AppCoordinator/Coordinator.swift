//
//  Coordinator.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

protocol Coordinator {
    var navigation: UINavigationController { get }
    
    func start()
}
