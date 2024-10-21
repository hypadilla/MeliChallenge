//
//  MessageDisplayable.swift
//  MeliChallenge
//
//  Created by Harold Padilla on 19/10/24.
//

import UIKit

protocol MessageDisplayable {
    func presentAlert(message: String, title: String)
}

extension MessageDisplayable where Self: UIViewController {
    func presentAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK".localized, style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
