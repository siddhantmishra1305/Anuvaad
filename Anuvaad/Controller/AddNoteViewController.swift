//
//  AddNoteViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import UIKit

class AddNoteViewController: UIViewController {

    
    @IBOutlet weak var titleTextFiel: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var micAnimationView: UIView!
    @IBOutlet weak var recordAudioBtn: UIButton!

    var note : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationItem.rightBarButtonItem = 
    }
    
    override func viewWillLayoutSubviews() {
        if let notesData = note{
            titleTextFiel.text = notesData.title
            bodyTextView.text = notesData.text
            
        }
    }
    
    
    @IBAction func recordBtnAction(_ sender: Any) {
        
        
    }
    
    


}
