//
//  TranslationViewModel.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import Foundation
import UIKit
import Speech

class TranslationViewModel{
    let synth = AVSpeechSynthesizer()
    
    func outputViewSetup(outputView:InputView,translatedView:UIView,vc:HomeViewController){
        outputView.isUserInteractionEnabled = false
        outputView.leftButton.isHidden = true
        outputView.frame.size = translatedView.frame.size
        translatedView.addSubview(outputView)
        translatedView.roundCorners(10.0)
        translatedView.addViewShadow(tag: 008)
        
        outputView.middleButton.addTarget(vc, action: #selector(vc.copyOutputToClipboard(_sender:)), for: .touchUpInside)
        outputView.rightButton.addTarget(vc, action: #selector(vc.speakOuptut(_sender:)), for: .touchUpInside)
    }
    
    func setTranslation(text:String,view:InputView?){
        DispatchQueue.main.async {
            view?.inputTextView.text = text
        }
    }
    
    func speech(text:String,code:String){
        if !synth.isSpeaking{
            let myUtterance = AVSpeechUtterance(string: text)
            myUtterance.voice = AVSpeechSynthesisVoice(language: code)
            synth.speak(myUtterance)
        }
    }
    
    func inputViewSetup(ipView:InputView,inputTranslationView:UIView,vc:HomeViewController){
        ipView.inputTextView.text = Constants.placeholder
        inputTranslationView.addSubview(ipView)
        ipView.frame.size = inputTranslationView.frame.size
        ipView.inputTextView.delegate = vc
        inputTranslationView.roundCorners(10.0)
        inputTranslationView.addViewShadow(tag: 009)
    
        ipView.leftButton.addTarget(vc, action: #selector(vc.deleteText(_sender:)), for: .touchUpInside)
        ipView.middleButton.addTarget(vc, action: #selector(vc.copyInputToClipboard(_sender:)), for: .touchUpInside)
        ipView.rightButton.addTarget(vc, action: #selector(vc.speakInput(_sender:)), for: .touchUpInside)
    }
    
    func getTranslation(text:String, sourceLanguageCode:String, destinationLanguageCode:String,handler:@escaping (String,NetworkError?)->Void){
        ServerManager.shared.request(router: ServerRequestRouter.getTranslation(text, sourceLanguageCode, destinationLanguageCode)) { (result:Result<TranslatedResponse,NetworkError>) in
            
            switch result{
            case .success(let response):
                handler(response.data?.translations?.first?.translatedText ?? "Something went wrong",nil)
                break
                
            case .failure(let error):
                handler("Unable to translate ! Try again",error)
                break
            }
        }
    }
    
    func getFilterLanguage(name:String)->Language?{
        return getLanguages()?.filter({$0.name == name}).first
    }
    
    func getLanguages()->Languages?{
        if let path = Bundle.main.path(forResource: "Language", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult : Languages = try JSONDecoder().decode(Languages.self, from: data)
                return jsonResult
            } catch {
                print("Invalid JSON")
            }
        }
        return nil
    }
    
}
