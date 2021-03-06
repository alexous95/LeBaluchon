//
//  TransferDataProtocol.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 07/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

// This protocol is used to create a delegate and pass data between our controllers
protocol TransferDataDelegate {
    func languageBack(language: String, buttonTag: Int)
}
