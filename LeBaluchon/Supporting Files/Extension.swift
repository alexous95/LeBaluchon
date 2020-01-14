//
//  Extension.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 29/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// This methode is used to show an alert controller to the user with custom title and message
    /// - Parameter title: The title for the alert
    /// - Parameter message: The message for the alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
