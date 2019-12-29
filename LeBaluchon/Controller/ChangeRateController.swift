//
//  ChangeRateController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class ChangeRateController: UIViewController {
    
    // MARK: - OUTLET
    
    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var exchangeRates: Exchange?
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        roundedUI()
        activityWheel.isHidden = true
    }
    
    // MARK: - Actions
    
    /// This action is used to retrieve the rates from the API. If there is an error an alert is shown.
    @IBAction func getRates() {
        guard Double(amountTF.text!) != nil else {
            showAlert(title: "Error", message: "You must enter a number to get the exchange rate")
            return
        }
        updateInterface(isHidden: convertButton.isHidden)
        activityWheel.startAnimating()
        ExchangeAPI().getExchange { (exchange, success) in
            if success {
                self.exchangeRates = exchange
                self.tableView.reloadData()
                self.updateInterface(isHidden: self.convertButton.isHidden)
                self.activityWheel.stopAnimating()
            } else {
                self.showAlert(title: "Error", message: "An error occured when retrieving the data")
                print("error")
            }
        }
    }
    
    // MARK: - Private methodes
    
    /// Get the amount choosen by the user
    /// - Returns: A double wich holds the amount choosen by the user
    private func getAmount() -> Double {
        if let amountString = amountTF.text {
            guard let amount = Double(amountString) else {
                return -1.0
            }
            return amount
        }
        return -1
    }
    
    /// Hide the convert button when a request is made and show the activity wheel during the request
    /// - Parameter isHidden: This parameter represents the state of the convertButton (hidden or not)
    private func updateInterface(isHidden: Bool) {
        activityWheel.isHidden = isHidden
        convertButton.isHidden = !isHidden
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        amountTF.delegate = self
    }
    
    private func roundedUI() {
        convertButton.layer.cornerRadius = 15
        tableView.layer.cornerRadius = 15
    }
    
}

// MARK: - Extension

extension ChangeRateController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension ChangeRateController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = exchangeRates?.rates.count else { return 0 }
        return section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "changeCell", for: indexPath) as? ExchangeTableViewCell else {
            return UITableViewCell()
        }
        
        // Get current keys
        guard let exchangeRates = exchangeRates?.rates else {
            return cell
        }
        var arrayKey = Array(exchangeRates.keys)
        arrayKey.sort()
        let currentKey = arrayKey[indexPath.row]
        let amount = getAmount()
        guard let exchangeRate = exchangeRates[currentKey] else { return cell }
        
        cell.configure(countryName: currentKey, moneyName: currentKey, moneyValue: String(format: "%.2F", (exchangeRate * amount)) )
        
        return cell
    }
    
}
