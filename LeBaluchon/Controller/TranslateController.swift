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
    
    // MARK: - Variables
    
    var translation: Translate?
    var backGradient = CAGradientLayer()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textToTranslate.delegate = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backGradient.frame = view.bounds
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sourceSegue" {
            
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
    
    // MARK: - Private
    
    /// This function is used to setup our view
    private func setupUI() {
        setupBackGradient()
       
        sourceLanguage.layer.borderColor = UIColor.white.cgColor
        textToTranslate.layer.borderColor = UIColor.white.cgColor
        translatedText.layer.borderColor = UIColor.white.cgColor
        targetLanguage.layer.borderColor = UIColor.white.cgColor
        translateButton.layer.borderColor = UIColor.white.cgColor
        
        sourceLanguage.layer.cornerRadius = sourceLanguage.frame.height/2
        targetLanguage.layer.cornerRadius = targetLanguage.frame.height/2
        translateButton.layer.cornerRadius = 10
        
        sourceLanguage.layer.borderWidth = 1.0
        targetLanguage.layer.borderWidth = 1.0
        translateButton.layer.borderWidth = 1.0
        textToTranslate.layer.borderWidth = 1.0
        translatedText.layer.borderWidth = 1.0
        
        textToTranslate.layer.cornerRadius = 10
        translatedText.layer.cornerRadius = 10
        
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
