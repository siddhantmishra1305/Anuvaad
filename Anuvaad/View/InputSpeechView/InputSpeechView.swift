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
    
    func startAnimating(){
        
        let animation = Animation.named("loading")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
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
