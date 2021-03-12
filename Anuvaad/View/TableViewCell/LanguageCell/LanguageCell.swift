//
//  LanguageCell.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 12/03/21.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var flag: UIImageView!{
        didSet{
//            flag.layer.cornerRadius = flag.bounds.size.width * 0.5
        }
    }
    
    @IBOutlet weak var languageName: UILabel!
    
    var cellData : [String:Any]?{
        didSet{
            if let code = cellData?["country"]{
                let url = "https://www.countryflags.io/\(code)/flat/64.png"
                flag.imageFromServerURL(url, placeHolder: nil)
                languageName.text = cellData?["name"] as? String
                self.roundCorners(10.0)
            }
        }
    }
}
