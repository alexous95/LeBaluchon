//
//  WeatherController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class WeatherController: UIViewController {

    var openWeather: OpenWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func getWeather(_ sender: Any) {
        OpenWeatherAPI().getExchange { (weather, success) in
            if success {
                self.openWeather = weather
            } else {
                print("erreur")
            }
        }
        if let openWeather = openWeather {
            print("Max temperature: \(openWeather.main.tempMax)")
            print("Min temperature: \(openWeather.main.tempMin)")
            print("Actual temperature: \(openWeather.main.temp)")
            print("\(openWeather.name)")
        }
        
    }
}
