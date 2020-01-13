//
//  ExchangeTableViewCell.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 27/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class ExchangeTableViewCell: UITableViewCell {

    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var currencyValue: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var backView: UIView!
    
    /// Methode to initialize the cells
    ///
    /// - Parameter countryName: The name of the image used to create an image from the assets
    /// - Parameter moneyName: The 3 letters name for the money
    /// - Parameter moneyValue: The value to display in the cell
    func configure(countryName: String, moneyName: String, moneyValue: String) {
        countryFlag.image = UIImage(named: countryName)
        currencyName.text = moneyName
        currencyValue.text = moneyValue
        setupView()
    }
    
    /// Methode to make our view rounded
    private func setupView() {
        backView.layer.cornerRadius = 20
    }
    
}
