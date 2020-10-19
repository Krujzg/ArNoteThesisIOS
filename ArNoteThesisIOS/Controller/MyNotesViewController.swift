//
//  MyNotesViewController.swift
//  ArNoteThesisIOS
//
//  Created by Gergo on 2020. 10. 13..
//

import UIKit
import Firebase
import ChameleonFramework

class MyNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var myNotesArray : [MyNote] = [MyNote]()
    
    @IBOutlet var myNotesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        myNotesTableView.delegate = self
        myNotesTableView.dataSource = self
        
        myNotesTableView.register(UINib(nibName: "CustomMyNotesCell", bundle: nil), forCellReuseIdentifier: "MyNoteCell")
        
        configureTableView()
        retrieveMessages()
        //myNotesTableView.separatorStyle = .none
    }
    
    func configureTableView()
    {
        myNotesTableView.rowHeight = UITableView.automaticDimension
        myNotesTableView.estimatedRowHeight = 120.0
    }
    
    func retrieveMessages(){
        
        let myNotesDb = Database.database().reference().child("MyNotes")
        
        myNotesDb.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            
            let shortcode = snapshotValue["shortcode"] as! String
            let type = snapshotValue["type"] as! String
            let date = snapshotValue["date"] as! String
            let textMessage = snapshotValue["textmessage"] as! String
            let myNote = MyNote(
                shortCode: shortcode,
                type: type,
                date: date,
                textMessage: textMessage)
            
            self.myNotesArray.append(myNote)
            self.configureTableView()
            self.myNotesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = myNotesTableView.dequeueReusableCell(withIdentifier: "MyNoteCell", for: indexPath) as! MyNotesCellTableViewCell
        
        cell.shortcode.text = myNotesArray[indexPath.row].shortcode
        cell.type.text = myNotesArray[indexPath.row].type
        cell.date.text = myNotesArray[indexPath.row].date
        cell.textMessage.text = myNotesArray[indexPath.row].textMessage
        
        if cell.type.text == "Normal"{
            cell.background.backgroundColor = UIColor.black
            cell.shortcode.textColor = UIColor.white
            cell.type.textColor = UIColor.white
            cell.date.textColor = UIColor.white
            cell.textMessage.textColor = UIColor.white
            cell.shortcodeTitle.textColor = UIColor.white
            cell.typeTitle.textColor = UIColor.white
            cell.dateTitle.textColor = UIColor.white
            cell.textTitle.textColor = UIColor.white
        }
        else if cell.type.text == "Urgent"{
            cell.background.backgroundColor = UIColor.red
            cell.shortcode.textColor = UIColor.white
            cell.type.textColor = UIColor.white
            cell.date.textColor = UIColor.white
            cell.textMessage.textColor = UIColor.white
            cell.shortcodeTitle.textColor = UIColor.white
            cell.typeTitle.textColor = UIColor.white
            cell.dateTitle.textColor = UIColor.white
            cell.textTitle.textColor = UIColor.white
        }
        else {
            cell.background.backgroundColor = UIColor.yellow
            cell.shortcode.textColor = UIColor.black
            cell.type.textColor = UIColor.black
            cell.date.textColor = UIColor.black
            cell.textMessage.textColor = UIColor.black
            cell.shortcodeTitle.textColor = UIColor.black
            cell.typeTitle.textColor = UIColor.black
            cell.dateTitle.textColor = UIColor.black
            cell.textTitle.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNotesArray.count
    }

}
