//
//  SignIn.swift
//  FirebaseSocialLogin
//
//  Created by Falguni Viral Chauhan on 22/03/18.
//  Copyright © 2018 Falguni Viral Chauhan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignIn: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func backPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInPress(_ sender: Any) {
        
        guard let password = passwordTextField.text else{ return }
        guard let email = emailTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print(err)
                return
            }
            
            if let currentUser = user {
                print(currentUser)
                self.performSegue(withIdentifier: "segue_ToHome", sender: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
