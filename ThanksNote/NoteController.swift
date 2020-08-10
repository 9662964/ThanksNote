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

class NoteController {

    func getNotes() {
        //get a reference to the database
        let db = Firestore.firestore()
        
        //get all the notes
        db.collection("notes").getDocuments { (snapshot, error) in
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
            }
        }
    }
}
