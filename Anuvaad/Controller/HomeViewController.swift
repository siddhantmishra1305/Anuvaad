//
//  ViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 11/03/21.
//

import UIKit

protocol LanguageSelection:AnyObject{
    func languageSelected(flag:UIImage,language:Language,sender:String)
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var translationView: UIStackView!
    
    @IBOutlet weak var translationContrl: UIStackView!
    @IBOutlet weak var sourceBtn: UIButton!
    @IBOutlet weak var swapBtn: UIButton!
    @IBOutlet weak var targetBtn: UIButton!
    
    @IBOutlet weak var translatedView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var inputTranslationView: UIView!
    
    let translationVM = TranslationViewModel()
    
    var sourceLanguage : Language?
    var targetLanguage : Language?
    
    var outputView  = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.first as! InputView
    var ipView = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.first as! InputView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.addSubview(bottomTabBar)
        bottomView.roundCorners(30.0)
        
        sourceLanguage = translationVM.getFilterLanguage(name: "English")!
        targetLanguage = translationVM.getFilterLanguage(name: "Hindi")!
        
        translationVM.outputViewSetup(outputView: outputView, translatedView: translatedView,vc:self)
        translationVM.inputViewSetup(ipView: ipView, inputTranslationView: inputTranslationView, vc: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomTabBar.selectedButton(index: 0)
    }
    
    @IBAction func sourceLanguage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let languageVC = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.delegate = self
        languageVC.sender = "Source"
        languageVC.currentLanguage = targetLanguage
        self.navigationController?.present(languageVC, animated: true, completion: nil)
    }
    
    @IBAction func swapLanguage(_ sender: Any) {
        
    }
    
    @IBAction func targetLanguage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let languageVC = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.sender = "Target"
        languageVC.delegate = self
        languageVC.currentLanguage = sourceLanguage
        self.navigationController?.present(languageVC, animated: true, completion: nil)
    }
    
}

extension HomeViewController:LanguageSelection{
    func languageSelected(flag: UIImage, language:Language,sender:String) {
        if sender == "Source"{
            sourceBtn.setTitle(language.name, for: .normal)
            sourceLanguage = language
        }else{
            targetBtn.setTitle(language.name, for: .normal)
            targetLanguage = language
            
            if ipView.inputTextView.text != Constants.placeholder{
                getTranslation(text: ipView.inputTextView.text)
            }
        }
    }
}

extension HomeViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.placeholder{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = Constants.placeholder
            outputView.inputTextView.text = nil
        }else{
            getTranslation(text: textView.text)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func getTranslation(text:String){
        outputView.activityStartAnimating(activityColor: Constants.textColor, backgroundColor: .white)
        if let source = sourceLanguage,let destination = targetLanguage{
            translationVM.getTranslation(text: text, sourceLanguageCode: source.language!, destinationLanguageCode: destination.language!) {[weak self] (translation, error) in
                self?.outputView.activityStopAnimating()
                if let err = error{
                    print(err)
                    self?.translationVM.setTranslation(text: translation, view: self?.outputView)
                }else{
                    self?.translationVM.setTranslation(text: translation, view: self?.outputView)
                }
            }
        }
    }
}

//MARK: Output View button actions
extension HomeViewController {
    @objc public func speakOuptut(_sender: UIButton) {
        if let text = outputView.inputTextView.text,let locale = targetLanguage?.code{
            translationVM.speech(text: text, code: locale)
        }
    }
    
    @objc func copyOutputToClipboard(_sender:UIButton){
        if let text = outputView.inputTextView.text{
            UIPasteboard.general.string = text
            self.showToast(message: "Copied to Clipboard", font: .systemFont(ofSize: 12.0))
        }
    }
    
}

//MARK: Input View button actions
extension HomeViewController {
    @objc public func speakInput(_sender: UIButton) {
        if let text = ipView.inputTextView.text,let locale = sourceLanguage?.code{
            translationVM.speech(text: text, code: locale)
        }
    }
    
    @objc func copyInputToClipboard(_sender:UIButton){
        if ipView.inputTextView.text != Constants.placeholder{
            UIPasteboard.general.string = ipView.inputTextView.text
            self.showToast(message: "Copied to Clipboard", font: .systemFont(ofSize: 12.0))
        }
    }
    
    @objc func deleteText(_sender:UIButton){
        ipView.inputTextView.text = Constants.placeholder
        outputView.inputTextView.text = nil
    }
}

