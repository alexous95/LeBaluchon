//
//  WeatherController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherController: UIViewController {
    
    // MARK: - Variables
    
    var weatherNY: OpenWeather?
    var weatherCurrent: OpenWeather?
    var lon: Double?
    var lat: Double?
    let gradientNY = CAGradientLayer()
    let backGradient = CAGradientLayer()
    let gradientCurrent = CAGradientLayer()
    let locationManager = CLLocationManager()
    
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
        setupLocation()
    }
    
    // Updates the UI only when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }
    
    // Sets anew the frame of all gradients to update their appearence if the dark mode is triggered
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientNY.frame = backViewNY.bounds
        gradientCurrent.frame = backViewCurrent.bounds
        backGradient.frame = view.bounds
        
        setupWeatherGradient()
        setupBackGradient()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailNYSegue" {
            let destVC = segue.destination as! DetailWeatherController
            destVC.weather = weatherNY
        }
        if segue.identifier == "detailCurrentSegue" {
            let destVC = segue.destination as! DetailWeatherController
            destVC.weather = weatherCurrent
        }
    }
    
    // MARK: - Private methodes
    
    /// This function is used to setup the location manager. The location accuracy is set to three kilometers to get
    /// quick result
    private func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            
            switch status {
            case .denied, .restricted:
                let alert = UIAlertController(title: "Location services disable", message: "Please enable location services in Settings", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                
                present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                locationManager.requestLocation()
                
            default:
                print("je sais pas quoi mettre ici")
            }
        }
    }
    
    /// Request the weather for New-York
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
    
    /// Requests the weather for the current location
    private func getCurrentWeather() {
        guard let lon = lon, let lat = lat else { return }
        OpenWeatherAPI().getCurrentWeather(lon: lon, lat: lat) { (currentWeather, success) in
            if success {
                self.weatherCurrent = currentWeather
                self.updateUI()
            } else {
                print("erreur")
            }
        }
    }
    
    /// Configures the labels and the views
    private func setupUI() {
        setupBackGradient()
        setupWeatherGradient()
        setupLabelNY()
        setupCurrentLabel()
    }
    
    /// Setsup the text label for the New-York part
    private func setupLabelNY() {
        cityLabelNY.text = ""
        tempLabelNY.text = ""
        maxTempNY.text = ""
        minTempNY.text = ""
        descriptionLabelNY.text = ""
    }
    
    /// Setsup the text label for the Current part
    private func setupCurrentLabel() {
        cityLabelCurrent.text = ""
        tempLabelCurrent.text = ""
        maxTempCurrent.text = ""
        minTempCurrent.text = ""
        descriptionLabelCurrent.text = ""
    }
    
    /// This function is used to setup the gradient on the two view that displays the weather. If we are on ios 13 or earlier
    /// we change the appearance based on the device
    private func setupWeatherGradient() {
        if #available(iOS 13.0, *) {
            // The color we use to create our gradient
            guard let startColor = UIColor(named: "StartColorWeather")?.resolvedColor(with: self.traitCollection) else { return }
            guard let endColor = UIColor(named: "EndColorWeather")?.resolvedColor(with: self.traitCollection) else { return }
            
            gradientNY.colors = [startColor.cgColor, endColor.cgColor]
            gradientCurrent.colors = [startColor.cgColor, endColor.cgColor]
            
            // We use insertSublayer to insure that the gradient is at the top of all the layers
            backViewNY.layer.insertSublayer(gradientNY, at: 0)
            backViewCurrent.layer.insertSublayer(gradientCurrent, at: 0)
            
        } else {
            guard let startColor = UIColor(named: "StartColorWeather") else { return }
            guard let endColor = UIColor(named: "EndColorWeather") else { return }
            
            gradientNY.colors = [startColor.cgColor, endColor.cgColor]
            gradientCurrent.colors = [startColor.cgColor, endColor.cgColor]
            
            backViewNY.layer.insertSublayer(gradientNY, at: 0)
            backViewCurrent.layer.insertSublayer(gradientCurrent, at: 0)
        }
    }
    
    /// This function is used to setup the gradient on the background view. If we are on ios 13 or earlier we change the appearance
    /// bases on the device
    private func setupBackGradient() {
        if #available(iOS 13.0, *) {
            guard let startColor = UIColor(named: "BackgroundStart")?.resolvedColor(with: self.traitCollection) else { return }
            guard let endColor = UIColor(named: "BackgroundEnd")?.resolvedColor(with: self.traitCollection) else { return }
            
            backGradient.colors = [startColor.cgColor, endColor.cgColor]
            
            view.layer.insertSublayer(backGradient, at: 0)
            
        } else {
            guard let startColor = UIColor(named: "BackgroundStart") else { return }
            guard let endColor = UIColor(named: "BackgoundEnd") else { return }
            let backGradient = CAGradientLayer()
            
            backGradient.frame = view.bounds
            backGradient.colors = [startColor.cgColor, endColor.cgColor]
            
            view.layer.insertSublayer(backGradient, at: 0)
        }
    }
    
    
    /// Update the labels and images from with the data received
    private func updateUI() {
        if let weatherNY = weatherNY {
            cityLabelNY.text = weatherNY.name
            tempLabelNY.text = String(format: "%.0F°C", weatherNY.main.temp)
            maxTempNY.text = String(format: "%.0F°C", weatherNY.main.tempMax)
            minTempNY.text = String(format: "%.0F°C", weatherNY.main.tempMin)
            descriptionLabelNY.text = weatherNY.weather[0].weatherDescription
            maxTempImageNY.image = UIImage(named: "MaxThermometer")
            minTempImageNY.image = UIImage(named: "MinThermometer")
            getNYIcon(identifier: weatherNY.weather[0].icon)
        }
        else {
            print("Failled to unwrap the weather object")
            return
        }
        if let currentWeather = weatherCurrent {
            cityLabelCurrent.text = currentWeather.name
            tempLabelCurrent.text = String(format: "%.0F°C", currentWeather.main.temp)
            maxTempCurrent.text = String(format: "%.0F°C", currentWeather.main.tempMax)
            minTempCurrent.text = String(format: "%.0F°C", currentWeather.main.tempMin)
            descriptionLabelCurrent.text = currentWeather.weather[0].weatherDescription
            maxTempImageCurrent.image = UIImage(named: "MaxThermometer")
            minTempImageCurrent.image = UIImage(named: "MinThermometer")
            getCurrentIcon(identifier: currentWeather.weather[0].icon)
        } else {
            print("failed to unwraped the currentWeather Object")
            return
        }
        
    }
    
    /// Request an icon from the OpenWeatherApi and assign the result to the image propriety of Imageview.
    /// To use this function you must have fetch the weather data
    /// - Parameter identifier: The identifier used by the api to recognize the icon
    private func getNYIcon(identifier: String) {
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
    
    /// Request an icon from the OpenWeatherApi and assign the result to the image propriety of Imageview.
    /// To use this function you must have fetch the weather data
    /// - Parameter identifier: The identifier used by the api to recognize the icon
    private func getCurrentIcon(identifier: String) {
        OpenWeatherAPI().getWeatherIcon(identifier: identifier) { (data, success) in
            if success {
                guard let data = data else { return }
                self.skyImageCurrent.image = UIImage(data: data)
            } else {
                print("On a pas d'image")
            }
        }
    }
}

// MARK: - Extensions

// This methodes are called only if the user allows to use the location serices
extension WeatherController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Une erreur est survenu et on a pas pus recuperer la localisation")
    }
    
    // This function is called every time the location change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lon = locValue.longitude
        lat = locValue.latitude
        getCurrentWeather()
    }
}
