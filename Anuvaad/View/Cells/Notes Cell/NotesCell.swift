//
//  NotesCell.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import UIKit

class NotesCell: UICollectionViewCell {
    
    @IBOutlet weak var notesData: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var cellData: Note?{
        didSet{
            notesData.text = cellData?.title ?? cellData?.text ?? ""
            date.text = cellData?.date.toString(format: "dd,MMM,yyyy")
        }
    }
    
}
