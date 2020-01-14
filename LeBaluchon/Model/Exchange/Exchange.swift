//
//  Exchange.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 17/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import Foundation

/// The struct to decode the data from the JSON file
struct Exchange: Codable {
    var success: Bool
    var base: String
    var date: Date
    var rates: [String:Double]
    
}
