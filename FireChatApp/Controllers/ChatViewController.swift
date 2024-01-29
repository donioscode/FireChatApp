//
//  ChatViewController.swift
//  FireChatApp
//
//  Created by doniyor normuxammedov on 07/12/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class ChatViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var messageTF: UITextField!
    private let database = Firestore.firestore()
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        tableview.register(UINib(nibName: "MessageTableViewCell", bundle: nil) ,forCellReuseIdentifier: "messageCell")
        tableview.dataSource = self
        loadMessagesFromFB()

    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let messageBody = messageTF.text
        let sender = Auth.auth().currentUser?.email

        
        if let messageBody = messageBody, let sender = sender{
            database.collection(Constants.messeges).addDocument(data: [Constants.body : messageBody, Constants.sender : sender, Constants.date: Date().timeIntervalSince1970]) { error in
                if let e = error{
                    print(e.localizedDescription)
                } else{
                    self.messageTF.text = ""
                    print("savedd!!")
                }
            }
        }
    }
    
    func loadMessagesFromFB(){
        database.collection(Constants.messeges)
            .order(by: Constants.date)
            .addSnapshotListener { snapshot, error in
                
                self.messages = []
                if error != nil{
                    print("Error ocurred when receiving data from FB \(error?.localizedDescription)")
                }else{
                    if let snapshotDoc = snapshot?.documents{
                        snapshotDoc.forEach { doc in
                            let data = doc.data()
                           
                            //print("DAta \(data)")
                            
                            if let sender = data[Constants.sender] as? String, let body = data[Constants.body] as? String{
                                let message = Message(sender: sender, message: body)
                                self.messages.append(message)
                                
                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableview.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
            }
        }
    
    @IBAction func LogOutPressed(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  messages.count
     }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.configure(message: messages[indexPath.row])
        return cell
    }
    
    
}
