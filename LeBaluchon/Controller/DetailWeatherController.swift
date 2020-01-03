//
//  DetailWeatherController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 02/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class DetailWeatherController: UIViewController {
    
    // MARK: - Variables
    
    var weather: OpenWeather?
    let numberOfSection = 6
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Extensions

extension DetailWeatherController: UITableViewDelegate, UITableViewDataSource {
    
    // We use this function to indicate the number of section in our tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }
    
    // We use this function to displaya custom string in our Header section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Clouds"
        case 1:
            return "Main information"
        case 2:
            return "Rain"
        case 3:
            return "Snow information"
        case 4:
            return "General info"
        case 5:
            return "Wind information"
        
        default:
            return "No category name"
        }
    }
    
    // We use this function to indicate the number of row we want in our sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 2
        case 5:
            return 2
        default:
            return 0
        }
    }
    
    // We use this function to configure our different cell for our tableview
    // We use several switch to configure what we want to display on screen
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // We use a formatter to display the date in a format readable
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? DetailWeatherCell else {
            return UITableViewCell()
        }
        
        guard let weather = weather else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        // Clouds information
        case 0:
            cell.configure(imageName: "Cloud", description: "Cloudiness", value: "\(weather.clouds?.all ?? 0) %")
            
        // Main information
        case 1:
            switch indexPath.row {
            case 0:
                cell.configure(imageName: "Thermometer", description: "Feels Like", value: "\(weather.main.feelsLike)°C")
            case 1:
                cell.configure(imageName: "Pressure", description: "Atmospheric pressure", value: "\(weather.main.pressure) hPa")
            case 2:
                cell.configure(imageName: "Humidity", description: "Humidity", value: "\(weather.main.humidity)%")
            default:
                return UITableViewCell()
            }
            
        // Rain information
        case 2:
            switch indexPath.row {
            case 0:
                cell.configure(imageName: "Rain", description: "Precipitation last hour", value: "\(weather.rain?.the1H ?? 0.0) mm")
            default:
                return UITableViewCell()
            }
            
        // Snow information
        case 3:
            switch indexPath.row {
            case 0:
                cell.configure(imageName: "Snow", description: "Falling snow last hour", value: "\(weather.snow?.the1H ?? 0.0) mm")
            case 1:
                cell.configure(imageName: "Snow", description: "Falling snow last 3H", value: "\(weather.snow?.the3H ?? 0.0) mm")
            default:
                return UITableViewCell()
            }
            
        // General info
        case 4:
            switch indexPath.row {
            case 0:
                let date = formatter.string(from: weather.sys.sunrise)
                cell.configure(imageName: "Sunrise", description: "Sunrise", value: date)
            case 1:
                let date = formatter.string(from: weather.sys.sunset)
                cell.configure(imageName: "Sunset", description: "Sunset", value: date)
            default:
                return UITableViewCell()
            }
            
        // Wind
        case 5:
            switch indexPath.row {
            case 0:
                cell.configure(imageName: "Wind", description: "Speed", value: "\(weather.wind.speed ?? 0.0) m/s")
            case 1:
                cell.configure(imageName: "Wind", description: "Direction", value: "\(weather.wind.deg ?? 0) deg")
            default:
                return UITableViewCell()
            }
        default:
            cell.configure(imageName: "MaxThermometer", description:"No value", value: "no value")
        }
        
        return cell
    }
}
