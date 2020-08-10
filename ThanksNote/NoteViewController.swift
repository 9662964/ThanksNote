//
//  NoteViewController.swift
//  ThanksNote
//
//  Created by iljoo Chae on 8/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    var note:Note?
    var noteController: NoteController?
    
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if note != nil {
            
            //User is viewing an existing note, so populate the fields
            titleTextField.text = note?.title
            bodyTextView.text = note?.body
            setStarButton()
        }else{
            //note property is nil, so created a new note
            var n = Note(docid: UUID().uuidString, title: titleTextField.text ?? "", body: bodyTextView.text ?? "", inStarred: false, createdAt: Date(), lastUpdatedAt: Date())

            self.note = n

        }
        
}
    
    func setStarButton() {
                    //Set the status of the star button
                    let imageName = note!.inStarred ? "star.fill" : "star"
        starBtn.setImage(UIImage(systemName: imageName), for: .normal)
                    
//                    if note!.inStarred {
//                        starBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
//                    }
//                    else
//                    {
//                        starBtn.setImage(UIImage(systemName: "star"), for: .normal)
//                        }
                

    }
    @IBAction func starBtnTapped(_ sender: Any) {
        //change the preperty in the note
        note?.inStarred.toggle()
        //update the database
        noteController?.updateFaveStatus(note!.docid, note!.inStarred)        //update the button
        setStarButton()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        //clear the field
        note = nil
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
   
    @IBAction func deleteBtnTapped(_ sender: Any) {
        if self.note != nil {
            noteController?.deleteNote(self.note!)
        }
        dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
 
        self.note?.title = titleTextField.text ?? ""
        self.note?.body = bodyTextView.text ?? ""
        self.note?.lastUpdatedAt = Date()
        
        //send it to the notes Controller
        self.noteController?.saveNote(self.note!)
        dismiss(animated: true, completion: nil)
    }
}
