//
//  SpeechAnalyzer.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 26/03/21.
//

import Foundation
import Speech

class SpeechAnalyzer:NSObject{
    
    public static var sharedInstance = SpeechAnalyzer()
    
    private override init() {}
    
    var regonizerAvailable : Bool?
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    var language:String!{
        didSet{
            speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: language))
        }
    }
    
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    var inputNode : AVAudioInputNode?
    
    func startRecording(text:@escaping (String?,Error?)->Void) {
        
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
        
        inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {[weak self] (result, error) in
            
            var isFinal = false
            
            if let res = result {
                text(res.bestTranscription.formattedString,nil)
                isFinal = res.isFinal
            }else if error != nil || isFinal{
                self?.audioEngine.stop()
                self?.inputNode?.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            text(nil,error)
            print("audioEngine couldn't start because of an error.")
        }
        
        print("Say something, I'm listening!")
    }
    
    
    func stopRecording(){
        inputNode?.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
    }
    
    deinit {
        print("Speech Initializer DeInitialized")
    }
    
}

extension SpeechAnalyzer: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            regonizerAvailable = true
        } else {
            regonizerAvailable = false
        }
    }
}
