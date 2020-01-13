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
    
    /// Methode to initialise a cell
    ///
    /// - Parameter imageName: The name of the file in the asset store
    /// - Parameter description: The description of a category from the weather object
    /// - Parameter value: The value associated to the description
    func configure(imageName: String, description: String, value: String) {
        descriptionImage.image = UIImage(named: imageName)
        descriptionName.text = description
        valueDescription.text = value
    }
    
}
