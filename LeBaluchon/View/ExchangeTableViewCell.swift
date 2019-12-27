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
    
    func configure(countryName: String, moneyName: String, moneyValue: String) {
        countryFlag.image = UIImage(named: countryName)
        currencyName.text = moneyName
        currencyValue.text = moneyValue
        setupView()
    }
    
    private func setupView() {
        backView.layer.cornerRadius = 20
    }
    
}
