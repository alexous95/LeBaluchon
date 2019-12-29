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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
