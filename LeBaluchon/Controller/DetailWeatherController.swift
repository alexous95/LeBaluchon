//
//  DetailWeatherController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 02/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class DetailWeatherController: UIViewController {
    
    var weather: OpenWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}

extension DetailWeatherController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

