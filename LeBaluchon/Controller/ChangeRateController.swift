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
    
    // MARK: - VARIABLES
    var exchangeRates: Exchange?
    
    // MARK: - VIEWLIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupDelegate()
        roundedUI()
        activityWheel.isHidden = true
    }
    
    // MARK: - ACTIONS
    
    /// This action is used to retrieve the rates from the API
    @IBAction func getRates() {
        updateInterface(isHidden: convertButton.isHidden)
        activityWheel.startAnimating()
        ExchangeAPI().getExchange { (exchange, success) in
            if success {
                self.exchangeRates = exchange
                self.tableView.reloadData()
                self.updateInterface(isHidden: self.convertButton.isHidden)
                self.activityWheel.stopAnimating()
            } else {
                print("erreur ")
            }
        }
    }
    
    // MARK: - PRIVATE
    private func getAmount() -> Double {
        if let amountString = amountTF.text {
            guard let amount = Double(amountString) else {
                print("on a pas rentrer un nombre")
                return -1.0
            }
            return amount
        }
        return -1
    }
    
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

// MARK: - EXTENSIONS

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
