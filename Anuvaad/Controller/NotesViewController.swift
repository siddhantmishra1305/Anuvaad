//
//  NotesViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import UIKit
import Foundation

struct ContextMenuItem {
  var title = ""
  var image = UIImage()
  var index = 0
}

protocol NoteAdded:AnyObject{
    func noteAdded(id:Int?)
}

class NotesViewController: BaseViewController ,NoteAdded{
    
    @IBOutlet weak var notesImageView: UIImageView!
    @IBOutlet weak var notesCollectionView: UICollectionView!
    @IBOutlet weak var addNewNote: UIButton!
    @IBOutlet weak var bottomBar: UIView!
    var notes : [Note]?{
        didSet{
            if notes?.count == 0{
                notesImageView.isHidden = false
            }else{
                notesImageView.isHidden = true
            }
        }
    }
    let noteVM = NotesViewModel()
    
    let contextMenuItems = [
        ContextMenuItem(title: "Copy", image: UIImage(systemName: "square.on.square")!, index: 0),
        ContextMenuItem(title: "Print", image: UIImage(systemName: "printer")!, index: 1),
        ContextMenuItem(title: "Delete", image: UIImage(systemName: "trash")!, index: 2)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomBar.addSubview(bottomTabBar)
        bottomBar.roundCorners(30.0)
        addNewNote.roundCorners(addNewNote.bounds.size.width * 0.5)
        notesCollectionView.register(UINib(nibName: "NotesCell", bundle: nil), forCellWithReuseIdentifier: "NotesCell")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomTabBar.selectedButton(index: 1)
    }
    
    func noteAdded(id: Int?) {
        loadNotes()
    }
    
    @IBAction func addNewNoteAction(_ sender: Any) {
        noteVM.navigateToNotes(note: nil, vc: self)
    }
    
    func loadNotes(){
        notes = noteVM.loadNotes()
        notesCollectionView.reloadData()
    }
}

extension NotesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCell", for: indexPath) as! NotesCell
        cell.cellData = notes?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        noteVM.navigateToNotes(note: notes?[indexPath.row], vc: self)
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(for: indexPath.row)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item % 3 == 0 {
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height/5)
        }else{
            return CGSize(width: collectionView.bounds.size.width/2 - 6 , height: collectionView.bounds.size.height/5)
        }
    }
    
    @available(iOS 13.0, *)
    func makeContextMenu(for index:Int) -> UIMenu {
        var actions = [UIAction]()
        for item in self.contextMenuItems {
            let action = UIAction(title: item.title, image: item.image, identifier: nil, discoverabilityTitle: nil) { _ in
                self.handleContextMenuActions(menuIndex: item.index, cellIndex: index)
            }
            actions.append(action)
        }
        let cancel = UIAction(title: "Cancel", attributes: .destructive) { _ in}
        actions.append(cancel)
        return UIMenu(title: "", children: actions)
    }
    
    func handleContextMenuActions(menuIndex:Int,cellIndex:Int){
        if let note = notes?[cellIndex]{
            switch menuIndex {
            case 0: // copy clipboard
                UIPasteboard.general.string = "\(note.title ?? " ")\n\(note.text ?? " ")"
                self.showToast(message: "Copied to Clipboard", font: .systemFont(ofSize: 12.0))
                break
                
            case 1 : // print
                break
                
            case 2 : // delete note
                noteVM.deleteNote(note: note)
                loadNotes()
                break

            default:
                fatalError()
            }
        }
    }
}

