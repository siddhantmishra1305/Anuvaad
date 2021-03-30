//
//  NotesViewModel.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 30/03/21.
//

import Foundation
import UIKit

class NotesViewModel{
    
    func navigateToNotes(note:Note?,vc:NotesViewController){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let addNotesVC = storyBoard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
        addNotesVC.delegate = vc
        addNotesVC.note = note
        addNotesVC.modalPresentationStyle = .overCurrentContext
        vc.navigationController?.present(addNotesVC, animated: false, completion: nil)
    }
    
    func loadNotes()->[Note]?{
        do {
            if let storedObjItem = UserDefaults.standard.object(forKey: Constants.notes) as? Data{
                let notes = try JSONDecoder().decode([Note].self, from: storedObjItem)
                return notes
            }else{
                print("No Data")
            }
        } catch let err {
            print(err)
        }
        return nil
    }
    
    func saveNote(note:Note){
        do {
            if let storedObjItem = UserDefaults.standard.object(forKey: Constants.notes) as? Data{
                var notes = try JSONDecoder().decode([Note].self, from: storedObjItem)
                notes.removeAll{$0.id == note.id}
                notes.append(note)
                let allNotes = try JSONEncoder().encode(notes)
                UserDefaults.standard.set(allNotes, forKey: Constants.notes)
            }else{
                let allNotes = try JSONEncoder().encode([note])
                UserDefaults.standard.set(allNotes, forKey: Constants.notes)
            }
        } catch let err {
            print(err)
        }
    }
    
    func deleteNote(note:Note){
        do {
            if let storedObjItem = UserDefaults.standard.object(forKey: Constants.notes) as? Data{
                var notes = try JSONDecoder().decode([Note].self, from: storedObjItem)
                notes.removeAll{$0.id == note.id}
                let allNotes = try JSONEncoder().encode(notes)
                UserDefaults.standard.set(allNotes, forKey: Constants.notes)
            }
        } catch let err {
            print(err)
        }
    }
}
