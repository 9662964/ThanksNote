//
//  ViewController.swift
//  ThanksNote
//
//  Created by iljoo Chae on 8/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var notes = [Note]()
    
    private var noteController = NoteController()
    
    
    
    private var isStarFiltered = false
    @IBOutlet weak var starBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        noteController.getNotes()
        
        //set self as the delegate for the notes model
        noteController.delegate = self
        
        //set the status of the star filter button
        setStarFilterButton()
        

    }
    
    func setStarFilterButton(){
        let imageName = isStarFiltered ? "star.fill" : "star"
        starBtn.image = UIImage(systemName: imageName)
    }
    
    @IBAction func starBtnTapped(_ sender: Any) {
        
        //Toggle the star filter status
        
        isStarFiltered.toggle()
        //run the query
        //ToDo: Retrieve all notes according to the filter status
        if isStarFiltered {
            noteController.getNotes(true)
            setStarFilterButton()
        }else{
            noteController.getNotes()
            setStarFilterButton()
        }
        
        //update the star button
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let noteViewController = segue.destination as! NoteViewController
        //if the user has selected a row, transition to note vc
        if tableView.indexPathForSelectedRow != nil {
            noteViewController.note = notes[tableView.indexPathForSelectedRow!.row]
            //deselect the selected row so that it does not interfere with new note creation
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
        //whether it is a new note or a selected note, we still want to pass through the notes controller
            noteViewController.noteController = self.noteController
        

    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)

        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = notes[indexPath.row].title
        let bodyLabel = cell.viewWithTag(2) as? UILabel
        bodyLabel?.text = notes[indexPath.row].body

        return cell
    }
    
    
}

extension ViewController: noteControllerProtocol {
    
    func notesRetrieved(notes: [Note]) {
        //Set notes property and refresh the table view
        self.notes = notes
        
        tableView.reloadData()
    }
    
    
}
