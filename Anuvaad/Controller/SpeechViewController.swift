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
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    var sourceLanguage : Language?{
        didSet{
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: sourceLanguage?.code ?? "en-US"))
        }
    }
    
    var targetLanguage : Language?
    
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomBar.addSubview(bottomTabBar)
        bottomBar.roundCorners(30.0)
        
        speechVM.outputViewSetup(outputView: outputView, translatedView: translatedOutputView, vc: self)
        speechVM.inputViewSetup(inputView: ipView, parentView: speechView, vc: self)
        speechRecognizer?.delegate = self
        
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
    
    func startRecording() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.ipView.speechText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.ipView.recordBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        print("Say something, I'm listening!")
    }
    
    @objc public func record(_sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.ipView.recordBtn.isEnabled = false
            self.ipView.recordBtn.setImage(UIImage(systemName: "record.circle"), for: .normal)
            self.ipView.recordBtn.setTitle(nil, for: .normal)
            startRecordingGIF(status: false)
        } else {
            self.startRecording()
            self.ipView.recordBtn.setImage(nil, for: .normal)
            self.ipView.recordBtn.setTitle("Stop", for: .normal)
            startRecordingGIF(status: true)
        }
    }
    
    func startRecordingGIF(status:Bool){
        if status{
            self.ipView.startAnimating()
        }else{
            self.ipView.stopAnimating()
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
