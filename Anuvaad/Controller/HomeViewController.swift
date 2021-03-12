//
//  ViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 11/03/21.
//

import UIKit

protocol LanguageSelection:AnyObject{
    func languageSelected(flag:UIImage,code:String,sender:String)
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
    
    var outputView   = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.first as! InputView
    var ipView = Bundle.main.loadNibNamed("InputView", owner: self, options: nil)?.first as! InputView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.addSubview(bottomTabBar)
        translatedView.addSubview(outputView)
        inputTranslationView.addSubview(ipView)
        
        bottomView.roundCorners(30.0)
        translatedView.roundCorners(10.0)
        translatedView.addViewShadow(tag: 008)
        inputTranslationView.roundCorners(10.0)
        inputTranslationView.addViewShadow(tag: 009)
    }

    @IBAction func sourceLanguage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let languageVC = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.delegate = self
        languageVC.sender = "Source"
        self.navigationController?.present(languageVC, animated: true, completion: nil)
    }
    
    @IBAction func swapLanguage(_ sender: Any) {
        
    }
    
    @IBAction func targetLanguage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let languageVC = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.sender = "Target"
        languageVC.delegate = self
        self.navigationController?.present(languageVC, animated: true, completion: nil)
    }
    
}

extension HomeViewController:LanguageSelection{
    func languageSelected(flag: UIImage, code: String,sender:String) {
        if sender == "Source"{
            sourceBtn.setImages(right: UIImage(systemName: "chevron.down"), left: flag)
        }else{
            targetBtn.setImages(right: UIImage(systemName: "chevron.down"), left: flag)
        }
    }
    
    
}
