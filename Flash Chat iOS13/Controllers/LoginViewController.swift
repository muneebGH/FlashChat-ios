//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email=emailTextfield.text,let password=passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
             
                if let e=error{
                    let alert = UIAlertController(title: "Could not login", message: e.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    self.performSegue(withIdentifier:Constants.loginSegue, sender: self)
                }
            }
        }
        
    }
    
}
