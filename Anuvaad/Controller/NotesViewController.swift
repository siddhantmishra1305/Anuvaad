//
//  NotesViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import UIKit
import Foundation

class NotesViewController: BaseViewController {
    
    @IBOutlet weak var notesCollectionView: UICollectionView!
    @IBOutlet weak var addNewNote: UIButton!
    var notes : [Note]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesCollectionView.register(UINib(nibName: "NotesCell", bundle: nil), forCellWithReuseIdentifier: "NotesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPlaces()
    }
    
    @IBAction func addNewNoteAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    
    func loadPlaces(){
        do {
            let storedObjItem = UserDefaults.standard.object(forKey: Constants.notes)
            notes = try JSONDecoder().decode([Note].self, from: storedObjItem as! Data)
        } catch let err {
            print(err)
            
        }
    }
}

extension NotesViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCell", for: indexPath) as! NotesCell
        cell.cellData = notes?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        homeVC.note = notes?[indexPath.row]
        self.navigationController?.pushViewController(homeVC, animated: false)
    }
    
    
}
