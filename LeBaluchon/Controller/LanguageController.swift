//
//  LanguageController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 07/01/2020.
//  Copyright © 2020 Alexandre Goncalves. All rights reserved.
//

import UIKit

class LanguageController: UIViewController {

    var languageList: SupportedLanguages?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getLanguages()
    }
    
    private func getLanguages() {
        TranslateAPI().getSupportedLanguages { (supportedList, success) in
            if success {
                self.languageList = supportedList
                self.tableView.reloadData()
            } else {
                print("On a un probleme")
            }
        }
    }
}

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
}
