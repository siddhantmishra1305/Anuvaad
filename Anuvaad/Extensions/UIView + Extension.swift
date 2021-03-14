//
//  UIView + Extension.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import Foundation
import UIKit



extension UIButton{
    func setImages(right: UIImage? = nil, left: UIImage? = nil) {
        if let leftImage = left, right == nil {
            setImage(leftImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 25), bottom: 5, right: 15)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: (imageView?.frame.width)!)
            contentHorizontalAlignment = .left
        }
        if let rightImage = right, left == nil {
            setImage(rightImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - 20))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: (imageView?.frame.width)!, bottom: 0, right: 10)
            contentHorizontalAlignment = .right
        }
        
        if let rightImage = right, let leftImage = left {
            setImage(rightImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - 20))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: (imageView?.frame.width)!, bottom: 0, right: 10)
            contentHorizontalAlignment = .left
            
            let leftImageView = UIImageView(frame: CGRect(x: bounds.maxX - 30,
                                                          y: (titleLabel?.bounds.midY)! - 5,
                                                          width: 20,
                                                          height: frame.height - 10))
            
            leftImageView.image?.withRenderingMode(.alwaysOriginal)
            leftImageView.image = leftImage
            leftImageView.contentMode = .scaleAspectFit
            leftImageView.layer.masksToBounds = true
            addSubview(leftImageView)
        }
        
    }
}

extension UIView{
    
    public func roundCorners(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    public func addViewShadow(tag:Int) {
        superview?.viewWithTag(tag)?.removeFromSuperview()
        
        //Create new shadow view with frame
        let shadowView = UIView(frame: frame)
        shadowView.tag = tag
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.layer.shouldRasterize = true
        
        superview?.insertSubview(shadowView, belowSubview: self)
    }
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 550, height: 550))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = Constants.primaryColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    
}
