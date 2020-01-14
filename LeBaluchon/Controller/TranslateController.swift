//
//  TranslateController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class TranslateController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var sourceLanguage: UIButton!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var targetLanguage: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    
    // MARK: - Variables
    
    var translation: Translate?
    var backGradient = CAGradientLayer()
    var source = "fr"
    var target = "en"
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textToTranslate.delegate = self
        setupUI()
    }
    
    // We use this methode to apply the dark mode 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backGradient.frame = view.bounds
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sourceSegue" {
            let destVC: LanguageController = segue.destination as! LanguageController
            destVC.buttonSender = sourceLanguage.tag
            destVC.delegate = self
        }
        if segue.identifier == "targetSegue" {
            let destVC: LanguageController = segue.destination as! LanguageController
            destVC.buttonSender = targetLanguage.tag
            destVC.delegate = self
        }
    }
    // MARK: - Action
    
    /// This function is used to query a translation from the input text
    @IBAction func getTranslation() {
        guard let source = sourceLanguage.titleLabel?.text else { return }
        guard let text = textToTranslate.text else { return }
        if text == "" {
            showAlert(title: "Oops", message: "You need to enter at least one word")
        }
        guard let target = targetLanguage.titleLabel?.text else { return }
        
        TranslateAPI().getTranslation(textToTranslate: text, sourceLanguage: source, targetLanguage: target) { (translate, success) in
            if success {
                self.translation = translate
                self.translatedText.text = self.translation?.data.translations[0].translatedText
            } else {
                print("erreur")
            }
        }
    }
    
    /// This action is used to swap the source and target languages
    @IBAction func swapTranslation(sender: UIButton!) {
        let tmp = source
        source = target
        target = tmp
        updateButton(newSource: source, newTarget: target)
    }
    
    // MARK: - Private
    
    /// This function is used to setup our view
    private func setupUI() {
        setupBackGradient()
        
        sourceLanguage.setTitle(source, for: .normal)
        targetLanguage.setTitle(target, for: .normal)
        
        sourceLanguage.tag = 1
        targetLanguage.tag = 2
    
        setupBorderColor()
        setupBorderWidth()
        setupCornerRadius()
    }
    
    /// Setup the border color for the UI elements
    private func setupBorderColor() {
        sourceLanguage.layer.borderColor = UIColor.white.cgColor
        textToTranslate.layer.borderColor = UIColor.white.cgColor
        translatedText.layer.borderColor = UIColor.white.cgColor
        targetLanguage.layer.borderColor = UIColor.white.cgColor
        translateButton.layer.borderColor = UIColor.white.cgColor
        swapButton.layer.borderColor = UIColor.white.cgColor
    }
    
    /// Setup the border width for the UI elements
    private func setupBorderWidth() {
        sourceLanguage.layer.borderWidth = 1.0
        targetLanguage.layer.borderWidth = 1.0
        translateButton.layer.borderWidth = 1.0
        textToTranslate.layer.borderWidth = 1.0
        translatedText.layer.borderWidth = 1.0
        swapButton.layer.borderWidth = 1.0
    }
    
    /// Setup the corner radius for the UI elements
    private func setupCornerRadius() {
        sourceLanguage.layer.cornerRadius = sourceLanguage.frame.height/2
        targetLanguage.layer.cornerRadius = targetLanguage.frame.height/2
        translateButton.layer.cornerRadius = 10
        textToTranslate.layer.cornerRadius = 10
        translatedText.layer.cornerRadius = 10
        swapButton.layer.cornerRadius = 10
    }
    
    /// Update the target button and source button title
    ///
    /// - Parameter newSource: The new source language
    /// - Parameter newTarget: The new target language
    private func updateButton(newSource: String, newTarget: String) {
        sourceLanguage.setTitle(newSource, for: .normal)
        targetLanguage.setTitle(newTarget, for: .normal)
    }
    
    /// Creates two colors to make a gradient that will be used by the background view
    private func setupBackGradient() {
        if #available(iOS 13.0, *) {
            guard let startColor = UIColor(named: "StartColorExchange")?.resolvedColor(with: self.traitCollection) else { return }
            guard let endColor = UIColor(named: "EndColorExchange")?.resolvedColor(with: self.traitCollection) else { return }
            
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
    
}

// MARK: - Extension

extension TranslateController: UITextViewDelegate {
    
    // This function is used to hide the keyboard when the return key is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension TranslateController: TransferDataDelegate {
    
    // Change the buttton from the selected language
    func languageBack(language: String, buttonTag: Int) {
        switch buttonTag {
        case 1:
            source = language
            sourceLanguage.setTitle(language, for: .normal)
        case 2:
            target = language
            targetLanguage.setTitle(language, for: .normal)
        default:
            print("On a un probleme")
        }
    }
}
