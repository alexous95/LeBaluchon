//
//  SettingsExchangeController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 13/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class SettingsExchangeController: UIViewController {

    // MARK: - Variable
    
    let gradient = CAGradientLayer()
    weak var delegate: TransferDeviseDelegate?
    var devise = ""
    var listDevise = ["EUR", "JPY", "USD", "GBP", "AUD", "CHF"]
    
    var pickerController = UIPickerView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var newDeviseTF: UITextField!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupPickerDelegate()
    
        newDeviseTF.inputView = pickerController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = view.bounds
        setupGradient()
    }
    
    // MARK: - Private
    
    private func setupTextField() {
        newDeviseTF.layer.borderColor = UIColor.white.cgColor
        newDeviseTF.layer.borderWidth = 1.0
    }
    
    private func setupPickerDelegate() {
        pickerController.delegate = self
        pickerController.dataSource = self
    }
    
    private func setupGradient() {
        if #available(iOS 13.0, *) {
            guard let startColor = UIColor(named: "StartColorExchange")?.resolvedColor(with: self.traitCollection) else { return }
            guard let endColor = UIColor(named: "EndColorExchange")?.resolvedColor(with: self.traitCollection) else { return }
            
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            view.layer.insertSublayer(gradient, at: 0)
            
        } else {
            guard let startColor = UIColor(named: "StartColorExchange") else { return }
            guard let endColor = UIColor(named: "EndColorExchange") else { return }
            
            gradient.frame = view.bounds
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            view.layer.insertSublayer(gradient, at: 0)
        }
    }
}

extension SettingsExchangeController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listDevise.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listDevise[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newDeviseTF.text = listDevise[row]
        newDeviseTF.resignFirstResponder()
        devise = listDevise[row]
        delegate?.deviseBack(devise)
    }
}
