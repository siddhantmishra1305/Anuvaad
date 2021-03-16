//
//  SpeechViewModel.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 15/03/21.
//

import Foundation
import UIKit
import Speech

class SpeechViewModel{
    
    func outputViewSetup(outputView:InputView,translatedView:UIView,vc:SpeechViewController){
        outputView.isUserInteractionEnabled = false
        outputView.leftButton.isHidden = true
        
        translatedView.addSubview(outputView)
        translatedView.roundCorners(10.0)
        translatedView.addViewShadow(tag: 008)
        
        outputView.leftButton.addTarget(vc, action: #selector(vc.deleteText(_sender:)), for: .touchUpInside)
        outputView.middleButton.addTarget(vc, action: #selector(vc.copyOutputToClipboard(_sender:)), for: .touchUpInside)
        outputView.rightButton.addTarget(vc, action: #selector(vc.speakOuptut(_sender:)), for: .touchUpInside)
    }
    
    func inputViewSetup(inputView:InputSpeechView,parentView:UIView,vc:SpeechViewController){
        parentView.addSubview(inputView)
        inputView.recordBtn.addTarget(vc, action: #selector(vc.record(_sender:)), for: .touchUpInside)
    }
    
    func setupSpeech(vc:SpeechViewController) {
        
        vc.ipView.recordBtn.isEnabled = false
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                fatalError()
            }
            
            OperationQueue.main.addOperation() {
                vc.ipView.recordBtn.isEnabled = isButtonEnabled
            }
        }
    }
}
