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
    @IBOutlet weak var titleLbl: UILabel!
    
    var cellData: Note?{
        didSet{
            notesData.text = cellData?.text ?? ""
            
            titleLbl.text =  cellData?.title ?? "(No Title)"
            
            date.text = cellData?.date.toString(format: "dd MMM,yyyy")
            self.layer.cornerRadius = 10.0
        }
    }
    
}
