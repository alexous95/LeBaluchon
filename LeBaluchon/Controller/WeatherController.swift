//
//  WeatherController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class WeatherController: UIViewController {

    // MARK: - Variables
    
    var openWeather: OpenWeather?
    
    // MARK: - Outlets
    
    @IBOutlet weak var backViewNY: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var skyImage: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Update the UI only when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }
  
    // MARK: - Private methodes
    
    /// Assign to the variable openWeather the result from the request
    private func getWeather() {
        OpenWeatherAPI().getWeather { (weather, success) in
            if success {
                self.openWeather = weather
                self.updateUI()
            } else {
                print("Erreur")
            }
        }
    }
    
    /// Update the labels and images from with the data received
    private func updateUI() {
        guard let weather = openWeather else { return }
        cityLabel.text = weather.name
        tempLabel.text = String(format: "%.0F°C", weather.main.temp)
        descriptionLabel.text = weather.weather[0].weatherDescription
        getIcon(identifier: weather.weather[0].icon)
        backViewNY.layer.cornerRadius = 20
    }
    
    /// Request an icon from the OpenWeatherApi and assign the result to the image propriety of Imageview.
    /// To use this function you must have fetch the weather data
    /// - Parameter identifier: The identifier used by the api to recognize the icon
    private func getIcon(identifier: String) {
        OpenWeatherAPI().getWeatherIcon(identifier: identifier) { (data, success) in
            if success {
                guard let data = data else {
                    return
                }
                self.skyImage.image = UIImage(data: data)
            } else {
                print("On a pas l'image")
            }
        }
    }
}
