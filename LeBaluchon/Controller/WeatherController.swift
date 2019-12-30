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
    
    var weatherNY: OpenWeather?
    var weatherCurrent: OpenWeather?
    
    // MARK: - Outlets
    
    @IBOutlet weak var backViewNY: UIView!
    @IBOutlet weak var cityLabelNY: UILabel!
    @IBOutlet weak var tempLabelNY: UILabel!
    @IBOutlet weak var maxTempNY: UILabel!
    @IBOutlet weak var minTempNY: UILabel!
    @IBOutlet weak var descriptionLabelNY: UILabel!
    @IBOutlet weak var skyImageNY: UIImageView!
    @IBOutlet weak var maxTempImageNY: UIImageView!
    @IBOutlet weak var minTempImageNY: UIImageView!
    
    @IBOutlet weak var backViewCurrent: UIView!
    @IBOutlet weak var cityLabelCurrent: UILabel!
    @IBOutlet weak var tempLabelCurrent: UILabel!
    @IBOutlet weak var maxTempCurrent: UILabel!
    @IBOutlet weak var minTempCurrent: UILabel!
    @IBOutlet weak var descriptionLabelCurrent: UILabel!
    @IBOutlet weak var skyImageCurrent: UIImageView!
    @IBOutlet weak var maxTempImageCurrent: UIImageView!
    @IBOutlet weak var minTempImageCurrent: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // Update the UI only when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }
  
    // MARK: - Private methodes
    
    /// Assign to the variable openWeather the result from the request
    private func getWeather() {
        OpenWeatherAPI().getNYWeather { (weather, success) in
            if success {
                self.weatherNY = weather
                self.updateUI()
            } else {
                print("Erreur")
            }
        }
    }
    
    /// Configure the labels and the views
    private func setupUI() {
        backViewNY.layer.cornerRadius = 20
        backViewCurrent.layer.cornerRadius = 20
        
        cityLabelNY.text = ""
        tempLabelNY.text = ""
        maxTempNY.text = ""
        minTempNY.text = ""
        descriptionLabelNY.text = ""
        
        cityLabelCurrent.text = ""
        tempLabelCurrent.text = ""
        maxTempCurrent.text = ""
        minTempCurrent.text = ""
        descriptionLabelCurrent.text = ""
    }
    
    /// Update the labels and images from with the data received
    private func updateUI() {
        guard let weather = weatherNY else { return }
        
        cityLabelNY.text = weather.name
        tempLabelNY.text = String(format: "%.0F°C", weather.main.temp)
        maxTempNY.text = String(format: "%.0F°C", weather.main.tempMax)
        minTempNY.text = String(format: "%.0F°C", weather.main.tempMin)
        descriptionLabelNY.text = weather.weather[0].weatherDescription
        
        maxTempImageNY.image = UIImage(named: "MaxThermometer")
        minTempImageNY.image = UIImage(named: "MinThermometer")
        getIcon(identifier: weather.weather[0].icon)
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
                self.skyImageNY.image = UIImage(data: data)
            } else {
                print("On a pas l'image")
            }
        }
    }
}
