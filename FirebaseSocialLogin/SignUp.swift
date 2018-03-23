//
//  SignUp.swift
//  FirebaseSocialLogin
//
//  Created by Falguni Viral Chauhan on 22/03/18.
//  Copyright © 2018 Falguni Viral Chauhan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUp: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func backPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func SignUpPress(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else{ return }
        guard let email = emailTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print(err)
                return
            }
            
            if let currentUser = user {
                print(currentUser)
                Auth.auth().currentUser?.createProfileChangeRequest().displayName = username
                Auth.auth().currentUser?.createProfileChangeRequest().commitChanges(completion: { (error) in
                    if let err = error {
                        print(err)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
