//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages:[Message]=[
        Message(sender: "1@2.com", body: "hi"),
        Message(sender: "a@b.com", body: "hello"),
        Message(sender: "1@2.com", body: "how are you buddy"),
        
    ]
    let db=Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        navigationItem.hidesBackButton=true
        title="⚡️FlashChat"
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
            if error != nil{
                
                print("there was an error getiing data from firestore")
                
            }else{
                
                self.messages=[]
                print("successfuly got data from firestore")
                if let snapshotDocs=querySnapshot?.documents{
                    
                    for doc in snapshotDocs{
                        
                        let data=doc.data()
                        if let sender=data[Constants.FStore.senderField] as? String,let body=data[Constants.FStore.bodyField] as? String{
                            self.messages.append(Message(sender: sender, body: body))
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath=IndexPath(row: self.messages.count-1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let body=messageTextfield.text,let sender=Auth.auth().currentUser?.email{
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField:sender,
                Constants.FStore.bodyField:body,
                Constants.FStore.dateField:Date().timeIntervalSince1970
            ]) { (error) in
                if error != nil{
                    print("error in saving to firestore")
                }else{
                    print("successfuly saved message to firestore")
                    DispatchQueue.main.async {
                        self.messageTextfield.text=""
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}


//MARK: - UITableViewDataSource


extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message=messages[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text=message.body
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden=true
            cell.rightImageView.isHidden=false
            cell.messageBubble.backgroundColor=UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor=UIColor(named:Constants.BrandColors.purple)
        }else{
            cell.leftImageView.isHidden=false
            cell.rightImageView.isHidden=true
            cell.messageBubble.backgroundColor=UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor=UIColor(named:Constants.BrandColors.lightPurple)
        }
        return cell
    }
    
    
    
    
}
