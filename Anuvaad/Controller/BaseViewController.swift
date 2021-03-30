//
//  BaseViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    var bottomTabBar: BottomBar! = Bundle.main.loadNibNamed("BottomBar", owner: self, options: nil)?.first as? BottomBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = Bundle.main.loadNibNamed("BottomBar", owner: self, options: nil)?.first as? BottomBar{
            bottomTabBar.frame = view.frame
        }
        
        bottomTabBar.homeBtn.addTarget(self, action: #selector(self.home(_sender:)), for: .touchUpInside)
        bottomTabBar.favBtn.addTarget(self, action: #selector(self.fav(_sender:)), for: .touchUpInside)
        bottomTabBar.speechBtn.addTarget(self, action: #selector(self.speech(_sender:)), for: .touchUpInside)
        bottomTabBar.settingsBtn.addTarget(self, action: #selector(self.settings(_sender:)), for: .touchUpInside)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc public func home(_sender: UIButton) {
        
        if let vc =  self.navigationController?.hasViewController(ofKind:HomeViewController.self){
            self.navigationController?.popToViewController(vc, animated: false)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(homeVC, animated: false)
        }
    }
    
    
    @objc public func fav(_sender: UIButton) {
        if let vc =  self.navigationController?.hasViewController(ofKind:NotesViewController.self){
            self.navigationController?.popToViewController(vc, animated: false)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let notesVC = storyBoard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            self.navigationController?.pushViewController(notesVC, animated: false)
        }
    }
    
    @objc public func speech(_sender: UIButton) {
        
        if let vc =  self.navigationController?.hasViewController(ofKind: SpeechViewController.self){
            self.navigationController?.popToViewController(vc, animated: false)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let speechVC = storyBoard.instantiateViewController(withIdentifier: "SpeechViewController") as! SpeechViewController
            self.navigationController?.pushViewController(speechVC, animated: false)
        }
    }
    
    @objc public func settings(_sender: UIButton) {
        
    }
    
}
