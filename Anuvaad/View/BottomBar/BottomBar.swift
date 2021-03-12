//
//  BottomBar.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import UIKit

class BottomBar: UIView {
    
    @IBOutlet weak var homeBtn: UIButton!{
        didSet{
            homeBtn.layer.cornerRadius = homeBtn.bounds.size.width * 0.5
        }
    }
    @IBOutlet weak var favBtn: UIButton!{
        didSet{
            favBtn.layer.cornerRadius = favBtn.bounds.size.width * 0.5
        }
    }
    @IBOutlet weak var speechBtn: UIButton!{
        didSet{
            speechBtn.layer.cornerRadius = speechBtn.bounds.size.width * 0.5
        }
    }
    
    @IBOutlet weak var settingsBtn: UIButton!{
        didSet{
            settingsBtn.layer.cornerRadius = settingsBtn.bounds.size.width * 0.5
        }
    }
    
    
    func selectedButton(btn : UIButton){
        switch btn {
        case homeBtn:
            
            setTintColor(color1: .white, color2: Constants.unselectedTintColor, color3: Constants.unselectedTintColor, color4: Constants.unselectedTintColor)
            homeBtn.backgroundColor = Constants.primaryColor
            
            break
            
        case favBtn:
            
            setTintColor(color1: Constants.unselectedTintColor, color2: .white, color3: Constants.unselectedTintColor, color4: Constants.unselectedTintColor)
            favBtn.backgroundColor = Constants.primaryColor
            break
            
        case speechBtn:
            
            setTintColor(color1: Constants.unselectedTintColor, color2: Constants.unselectedTintColor, color3: .white, color4: Constants.unselectedTintColor)
            speechBtn.backgroundColor = Constants.primaryColor
            break
            
        case settingsBtn:
            
            setTintColor(color1: Constants.unselectedTintColor, color2: Constants.unselectedTintColor, color3: Constants.unselectedTintColor, color4: .white)
            settingsBtn.backgroundColor = Constants.primaryColor
            break
            
        default:
            print("Invalid Choice")
        }
    }
    
    func setTintColor(color1:UIColor,color2:UIColor,color3:UIColor,color4:UIColor){
        homeBtn.tintColor = color1
        favBtn.tintColor = color2
        speechBtn.tintColor = color3
        settingsBtn.tintColor = color4
        
        homeBtn.backgroundColor = .white
        favBtn.backgroundColor = .white
        speechBtn.backgroundColor = .white
        settingsBtn.backgroundColor = .white
        
    }
    
}
