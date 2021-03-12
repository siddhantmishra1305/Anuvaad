//
//  BaseViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import UIKit

class BaseViewController: UIViewController {

    
    var bottomTabBar: BottomBar!  =  Bundle.main.loadNibNamed("BottomBar", owner: self, options: nil)?.first as? BottomBar
    
    
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
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    
    @objc public func home(_sender: UIButton) {
        bottomTabBar.selectedButton(btn: _sender)
    }
    
    
    @objc public func fav(_sender: UIButton) {
        bottomTabBar.selectedButton(btn: _sender)
    }
    
    @objc public func speech(_sender: UIButton) {
        bottomTabBar.selectedButton(btn: _sender)
    }
    
    @objc public func settings(_sender: UIButton) {
        bottomTabBar.selectedButton(btn: _sender)
    }

}
