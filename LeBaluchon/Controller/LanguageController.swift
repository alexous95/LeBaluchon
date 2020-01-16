//
//  LanguageController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 07/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class LanguageController: UIViewController {

    // MARK: - Variables
    
    var languageList: SupportedLanguages?
    var delegate: TransferDataDelegate?
    var buttonSender: Int?
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getLanguages()
    }
    
    // MARK: - Private
    
    /// This methode request for the Supported language from google API
    private func getLanguages() {
        guard let request = TranslateAPI().createLanguageRequest() else { return }
        
        RequestManager().launch(request: request, api: .language) { (data, success) in
            if success {
                guard let supportedList = data as! SupportedLanguages? else { return }
                self.languageList = supportedList
                self.tableView.reloadData()
            } else {
                self.showAlert(title: "Oops", message: "An error occured. Please check your Wi-Fi network")
            }
        }
    }
}

// MARK: - Extension
extension LanguageController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = languageList?.data.languages.count else {
            return 0
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        
        guard let language = languageList?.data.languages[indexPath.row].language else {
            print("On renvoie une cellule vide")
            return UITableViewCell()
        }
        
        guard let description = languageList?.data.languages[indexPath.row].name else {
            print("On renvois encore une cellule vide")
            return UITableViewCell()
        }
        
        cell.textLabel?.text = description
        cell.detailTextLabel?.text = language
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newLanguage = languageList?.data.languages[indexPath.row].language else { return }
        guard let tag = buttonSender else { return }
        delegate?.languageBack(language: newLanguage, buttonTag: tag)
        dismiss(animated: true, completion: nil)
    }
}
