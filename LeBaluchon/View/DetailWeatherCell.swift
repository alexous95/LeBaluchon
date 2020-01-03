//
//  DetailWeatherCell.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 02/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class DetailWeatherCell: UITableViewCell {

    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var valueDescription: UILabel!
    @IBOutlet weak var descriptionName: UILabel!
    
    func configure(imageName: String, description: String, value: String) {
        descriptionImage.image = UIImage(named: imageName)
        descriptionName.text = description
        valueDescription.text = value
    }
    
}
