//
//  TranslateController.swift
//  LeBaluchon
//
//  Created by Alexandre Goncalves on 10/12/2019.
//  Copyright © 2019 Alexandre Goncalves. All rights reserved.
//

import UIKit

class TranslateController: UIViewController {

    @IBOutlet weak var sourceLanguage: UIButton!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var targetLanguage: UIButton!
    
    var translation: Translate?
    var backGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backGradient.frame = view.bounds
        setupUI()
    }
    
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
    
    private func setupUI() {
        setupBackGradient()
        
        textToTranslate.text = ""
        translatedText.text = ""
        
        sourceLanguage.layer.borderColor = UIColor.white.cgColor
        textToTranslate.layer.borderColor = UIColor.white.cgColor
        translatedText.layer.borderColor = UIColor.white.cgColor
        targetLanguage.layer.borderColor = UIColor.white.cgColor
        translateButton.layer.borderColor = UIColor.white.cgColor
        
        sourceLanguage.layer.borderWidth = 1.0
        targetLanguage.layer.borderWidth = 1.0
        translateButton.layer.borderWidth = 1.0
        textToTranslate.layer.borderWidth = 1.0
        translatedText.layer.borderWidth = 1.0
        
        textToTranslate.layer.cornerRadius = 10
        translatedText.layer.cornerRadius = 10
        
    }
    
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
