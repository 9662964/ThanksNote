//
//  NoteController.swift
//  ThanksNote
//
//  Created by iljoo Chae on 8/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol noteControllerProtocol {
    func notesRetrieved(notes:[Note])
}


class NoteController {
    
    var delegate: noteControllerProtocol?
    var listener: ListenerRegistration?
    deinit {
        //Unregister database listener
        listener?.remove()
    }

    func getNotes(_ starredOnly:Bool = false) {
        
        //detach any listener
        listener?.remove()
        
        
        //get a reference to the database
        let db = Firestore.firestore()
        
        var query: Query = db.collection("notes")
        
        //if we are only looking for starred notes, update the query
        if starredOnly {
            query = query.whereField("isStarred", isEqualTo: true)
        }
        
        
        //get all the notes
        self.listener = query.addSnapshotListener() { (snapshot, error) in
            //check for errors
            if error == nil && snapshot != nil {
                var notes = [Note]()
                
                //parse documents into Notes
                for doc in snapshot!.documents {
                    
                    let createdAtDate:Date = Timestamp.dateValue(doc["createdAt"] as! Timestamp)()
                    let lastUpdatedDate:Date = Timestamp.dateValue(doc["lastUpdatedAt"] as! Timestamp)()
                    
                    
                    let n = Note(docid: doc["docid"] as! String, title: doc["title"] as! String, body: doc["body"] as! String, inStarred: doc["isStarred"] as! Bool, createdAt: createdAtDate, lastUpdatedAt: lastUpdatedDate)
                    
                    notes.append(n)
                }
                
                //call the delegate and pass back the notes in the main thread
                DispatchQueue.main.async {
                    self.delegate?.notesRetrieved(notes: notes)                     
                }

            }
        }
    }
    
    func deleteNote(_ n:Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docid).delete()
    }
    
    func saveNote(_ n:Note) {
        let db = Firestore.firestore()
        db.collection("notes").document(n.docid).setData(noteToDictionary(n))
    }
    
    func updateFaveStatus(_ docid:String, _ isStarred:Bool) {
        let db = Firestore.firestore()
        db.collection("notes").document(docid).updateData(["isStarred":isStarred])
    }
    
    
    func noteToDictionary(_ n:Note) -> [String:Any] {
        var dict = [String:Any]()
        
        dict["docid"] = n.docid
        dict["title"] = n.title
        dict["body"] = n.body
        dict["createdAt"] = n.createdAt
        dict["lastUpdatedAt"] = n.lastUpdatedAt
        dict["isStarred"] = n.inStarred
        
        return dict
    }
}
