//
//  SpeechViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 15/03/21.
//

import UIKit
import Speech

class SpeechViewController: BaseViewController {
    
    @IBOutlet weak var targetLanguageBtn: UIButton!
    @IBOutlet weak var sourceLanguageBtn: UIButton!
    @IBOutlet weak var translatedOutputView: UIView!
    @IBOutlet weak var speechView: UIView!
    
    @IBOutlet weak var bottomBar: UIView!
    
    let translationVM = TranslationViewModel()
    let speechVM = SpeechViewModel()
    
    var outputView  = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.first as! InputView
    var ipView = Bundle.main.loadNibNamed("InputSpeechView", owner: self, options: nil)?.first as! InputSpeechView

    
    var sourceLanguage : Language?{
        didSet{
            SpeechAnalyzer.sharedInstance.language = sourceLanguage?.code ?? "en-US"
        }
    }
    
    var targetLanguage : Language?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomBar.addSubview(bottomTabBar)
        bottomBar.roundCorners(30.0)
        
        speechVM.outputViewSetup(outputView: outputView, translatedView: translatedOutputView, vc: self)
        speechVM.inputViewSetup(inputView: ipView, parentView: speechView, vc: self)
        
        sourceLanguage = translationVM.getFilterLanguage(name: "English")!
        targetLanguage = translationVM.getFilterLanguage(name: "Hindi")!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomTabBar.selectedButton(index: 2)
    }
    
    @IBAction func targetLanguageAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let languageVC = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.delegate = self
        languageVC.sender = "Target"
        languageVC.currentLanguage = sourceLanguage
        self.navigationController?.present(languageVC, animated: true, completion: nil)
    }
    
    @IBAction func sourceLanguageAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let languageVC = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.delegate = self
        languageVC.sender = "Source"
        languageVC.currentLanguage = targetLanguage
        self.navigationController?.present(languageVC, animated: true, completion: nil)
    }
}


//MARK: Output View button actions
extension SpeechViewController {
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
    
    @objc func deleteText(_sender:UIButton){
        ipView.speechText.text = nil
        outputView.inputTextView.text = nil
    }
}

//MARK: InputView button action
extension SpeechViewController {

    @objc public func record(_sender: UIButton) {
        if SpeechAnalyzer.sharedInstance.audioEngine.isRunning {
            SpeechAnalyzer.sharedInstance.stopRecording()
            startRecordingGIF(status: false)
        } else {
            startRecordingGIF(status: true)
            SpeechAnalyzer.sharedInstance.startRecording {[weak self] (text, error) in
                if let err = error{
                    self?.startRecordingGIF(status: false)
                    self?.ipView.speechText.text = err.localizedDescription
                }else{
                    self?.ipView.speechText.text = text
                }
            }
        }
    }
    
    func startRecordingGIF(status:Bool){
        if status{
            self.ipView.startRecordingAnimation()
        }else{
            self.ipView.stopRecordingAnimation()
            getTranslation()
        }
    }
    
    func getTranslation(){
        if self.ipView.speechText.text != Constants.speechPlaceolder{
            if let src = sourceLanguage?.language,let target = targetLanguage?.language,let text = self.ipView.speechText.text{
                self.outputView.activityStartAnimating(activityColor: Constants.textColor, backgroundColor: Constants.backgroundColor)
                translationVM.getTranslation(text: text, sourceLanguageCode: src, destinationLanguageCode: target) {[weak self](translation, error) in
                    self?.outputView.activityStopAnimating()
                    if let err = error{
                        self?.outputView.inputTextView.text = err.localizedDescription
                    }else{
                        self?.outputView.inputTextView.text = translation
                    }
                }
            }
        }
    }
}

extension SpeechViewController:LanguageSelection{
    func languageSelected(flag: UIImage, language:Language,sender:String) {
        if sender == "Source"{
            sourceLanguageBtn.setTitle(language.name, for: .normal)
            sourceLanguage = language
        }else{
            targetLanguageBtn.setTitle(language.name, for: .normal)
            targetLanguage = language
            getTranslation()
        }
    }
}

extension SpeechViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.ipView.recordBtn.isEnabled = true
        } else {
            self.ipView.recordBtn.isEnabled = false
        }
    }
}
