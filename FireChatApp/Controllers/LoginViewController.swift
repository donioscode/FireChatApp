//
//  LoginViewController.swift
//  FireChatApp
//
//  Created by doniyor normuxammedov on 07/12/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

       // LoginToChat
    

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if let email = emailTF.text,let password = passwordTF.text{
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error{
                    print(e)
                }else{
                    self.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
            }
            
        }
    
    }
  
}
