//
//  ChangeRateController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class ChangeRateController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    var exchangeRates: Exchange?
    let request = ExchangeAPI().createExchangeRequest()
    let gradient = CAGradientLayer()

    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        activityWheel.isHidden = true
        getRatesForOne()
    }
    
    // This methode is used to update the UI if the dark mode is activated
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
        setupUI()
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
        
        RequestManager().launch(request: request, api: .fixer) { (data, success) in
            if success {
                guard let exchange = data as! Exchange? else { return }
                self.exchangeRates = exchange
                self.tableView.reloadData()
                self.updateInterface(isHidden: self.convertButton.isHidden)
                self.activityWheel.stopAnimating()
                self.view.endEditing(true)
            } else {
                self.showAlert(title: "Error", message: "An error occured. Please check your network connection")
                print("error")
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTF.resignFirstResponder()
    }
    
    // MARK: - Private methodes
    
    /// Get the amount choosen by the user
    ///
    /// - Returns: A double wich holds the amount choosen by the user
    private func getAmount() -> Double {
        if let amountString = amountTF.text {
            guard let amount = Double(amountString) else {
                return -1.0
            }
            return amount
        }
        return 1
    }
    
    /// Get the change rate for one Euro
    private func getRatesForOne() {
        RequestManager().launch(request: request, api: .fixer) { (data, success) in
            if success {
                guard let exchange = data as! Exchange? else { return }
                self.exchangeRates = exchange
                self.tableView.reloadData()
            } else {
                self.showAlert(title: "Oops", message:"An error occured. Please check your network connection")
            }
        }
    }
    
    /// Hides the convert button when a request is made and shows the activity wheel during the request
    ///
    /// - Parameter isHidden: This parameter represents the state of the convertButton (hidden or not)
    private func updateInterface(isHidden: Bool) {
        activityWheel.isHidden = isHidden
        convertButton.isHidden = !isHidden
    }
    
    /// Sets the delegates to the ViewController
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Setsup the UI elements
    private func setupUI() {
        setupGradient()
        setupBorderWidth()
        setupBorderColor()
    }
    
    /// Setsup the border width for the UI elements
    private func setupBorderWidth() {
        convertButton.layer.borderWidth = 1.0
        amountTF.layer.borderWidth = 1.0
    }
        
    /// Setsup the border color for the UI elements
    private func setupBorderColor() {
        convertButton.layer.borderColor = UIColor.white.cgColor
        amountTF.layer.borderColor = UIColor.white.cgColor
    }
    
    /// Setsup the background gradient
    private func setupGradient() {
        if #available(iOS 13.0, *) {
            guard let startColor = UIColor(named: "StartColorExchange")?.resolvedColor(with: self.traitCollection) else { return }
            guard let endColor = UIColor(named: "EndColorExchange")?.resolvedColor(with: self.traitCollection) else { return }
            
            
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            view.layer.insertSublayer(gradient, at: 0)
            
            convertButton.layer.borderColor = UIColor.white.cgColor
            convertButton.layer.borderWidth = 1.0
            
            amountTF.layer.borderColor = UIColor.white.cgColor
            amountTF.layer.borderWidth = 1.0
            
        } else {
            guard let startColor = UIColor(named: "StartColorExchange") else { return }
            guard let endColor = UIColor(named: "EndColorExchange") else { return }
            let gradient = CAGradientLayer()
            
            gradient.frame = view.bounds
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            view.layer.insertSublayer(gradient, at: 0)
        }
    }
}

// MARK: - Extension

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
        
        if amount == -1 {
            cell.configure(countryName: currentKey, moneyName: currentKey, moneyValue: String(format: "%.2F", (exchangeRate * 1)))
        } else {
            cell.configure(countryName: currentKey, moneyName: currentKey, moneyValue: String(format: "%.2F", (exchangeRate * amount)))
        }
        return cell
    }
}
