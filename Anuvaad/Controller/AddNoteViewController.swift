//
//  AddNoteViewController.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import UIKit
import Lottie
import Speech


class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextFiel: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var RecordAudioBtn: UIButton!{
        didSet{
            RecordAudioBtn.roundCorners(RecordAudioBtn.frame.size.width * 0.5)
        }
    }
    
    @IBOutlet weak var parentView: UIView!{
        didSet{
            parentView.roundCorners(10)
        }
    }
    
    @IBOutlet weak var animationView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UIButton!{
        didSet{
            saveBtn.roundCorners(16.0)
        }
    }
    
    weak var delegate : NoteAdded?
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    var note : Note?
    
    let animationGIFView = AnimationView()
    
    let noteViewModel = NotesViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        if let notesData = note{
            titleTextFiel.text = notesData.title
            bodyTextView.text = notesData.text
        }
    }
    
    @IBAction func recordAudioBtnAction(_ sender: Any) {
        if SpeechAnalyzer.sharedInstance.audioEngine.isRunning {
            SpeechAnalyzer.sharedInstance.stopRecording()
            startRecordingGIF(status: false)
        } else {
            startRecordingGIF(status: true)
            SpeechAnalyzer.sharedInstance.startRecording {[weak self] (text, error) in
                if let err = error{
                    self?.startRecordingGIF(status: false)
                    self?.bodyTextView.text = err.localizedDescription
                }else{
                    self?.bodyTextView.text = text
                    
                }
            }
        }
    }
    
    func startRecordingGIF(status:Bool){
        if status{
            RecordAudioBtn.setImage(nil, for: .normal)
            RecordAudioBtn.setTitle("Stop", for: .normal)
            self.startAnimating()
        }else{
            RecordAudioBtn.setImage(UIImage(systemName: "mic"), for: .normal)
            RecordAudioBtn.setTitle(nil, for: .normal)
            self.stopAnimating()
        }
    }
    
    func startAnimating(){
        let animation = Animation.named("loading")
        animationGIFView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationGIFView.frame.size = animationView.frame.size
        animationView.addSubview(animationGIFView)
        animationGIFView.loopMode = .loop
        animationGIFView.backgroundBehavior = .pauseAndRestore
        animationGIFView.play()
    }
    
    func stopAnimating(){
        animationGIFView.stop()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveNoteAction(_ sender: Any) {
        if bodyTextView.text.count > 0 && titleTextFiel.text?.count ?? 0 > 0{
            if note != nil{
                note!.text = bodyTextView.text
                note!.title = titleTextFiel.text
            }else{
                note = Note(title: titleTextFiel.text!, body: bodyTextView.text)
            }
            saveNote()
        }else{
            self.showToast(message: "Invalid data", font: .systemFont(ofSize: 14))
        }
    }
    
    
    func saveNote(){
        noteViewModel.saveNote(note: note!)
        delegate?.noteAdded(id: note?.id)
        dismiss(animated: false, completion: nil)
    }
}

extension AddNoteViewController : UITextViewDelegate,UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.placeholder{
            textView.text = nil
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
