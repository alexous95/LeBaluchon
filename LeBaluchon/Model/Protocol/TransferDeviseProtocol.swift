//
//  TransferDeviseProtocol.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 13/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import Foundation

protocol TransferDeviseDelegate: class {
    func deviseBack(_ devise: String)
}
