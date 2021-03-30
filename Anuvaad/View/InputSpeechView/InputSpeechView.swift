//
//  InputSpeechView.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 15/03/21.
//

import UIKit
import Lottie

class InputSpeechView: UIView {
    
    @IBOutlet weak var speechText: UILabel!
    @IBOutlet weak var recordingAnimationView: UIView!
    @IBOutlet weak var recordBtn: UIButton!
    
    let animationView = AnimationView()
    
    
    func stopRecordingAnimation(){
        recordBtn.setImage(UIImage(systemName: "record.circle"), for: .normal)
        recordBtn.setTitle(nil, for: .normal)
        stopAnimating()
    }
    
    func startRecordingAnimation(){
        recordBtn.setImage(nil, for: .normal)
        recordBtn.setTitle("Stop", for: .normal)
        startAnimating()
    }
    
    func startAnimating(){
        let animation = Animation.named("loading")
        animationView.animation = animation
        animationView.contentMode = .scaleToFill
        animationView.frame.size = recordingAnimationView.frame.size
        recordingAnimationView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
    }
    
    func stopAnimating(){
        animationView.stop()
    }
    
}
