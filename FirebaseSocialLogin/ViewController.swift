//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by Falguni Viral Chauhan on 19/03/18.
//  Copyright © 2018 Falguni Viral Chauhan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    let fbLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    let customFbLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Custom FB login", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let customGoogleSingInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Custom Google login", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email"]
        
        [fbLoginButton, customFbLoginButton, googleSignInButton, customGoogleSingInButton].forEach{view.addSubview($0)}
        
        customFbLoginButton.addTarget(self, action: #selector(handleFBLoginClick), for: UIControlEvents.touchUpInside)
        
        customGoogleSingInButton.addTarget(self, action: #selector(handleGoogleLoginClick), for: .touchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        prepareButtons()
    }

    @objc func handleFBLoginClick (){
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            print("Custom FB login successfully.")
            self.showEmailAddress()
        }
    }
    
    @objc func handleGoogleLoginClick() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did you logout")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Login successfully")
        showEmailAddress()
    }

    func showEmailAddress() {
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let user = user {
                print("User from firebase :\(user)")
            }
        }
        
        FBSDKGraphRequest.init(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            print(result as Any)
        }
    }
}
extension ViewController {
    
    func prepareButtons() {
        fbLoginButtons()
        googleButtons()
        
    }
    
    fileprivate func googleButtons() {
        googleSignInButton.leadingAnchor.constraint(equalTo: fbLoginButton.leadingAnchor).isActive = true
        googleSignInButton.topAnchor.constraint(equalTo: customFbLoginButton.bottomAnchor, constant: 20).isActive = true
        googleSignInButton.trailingAnchor.constraint(equalTo: fbLoginButton.trailingAnchor).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        customGoogleSingInButton.leadingAnchor.constraint(equalTo: fbLoginButton.leadingAnchor).isActive = true
        customGoogleSingInButton.topAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: 20).isActive = true
        customGoogleSingInButton.trailingAnchor.constraint(equalTo: fbLoginButton.trailingAnchor).isActive = true
        customGoogleSingInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    fileprivate func fbLoginButtons() {
        fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fbLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fbLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15).isActive = true
        fbLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        customFbLoginButton.leadingAnchor.constraint(equalTo: fbLoginButton.leadingAnchor).isActive = true
        customFbLoginButton.topAnchor.constraint(equalTo: fbLoginButton.bottomAnchor, constant: 20).isActive = true
        customFbLoginButton.trailingAnchor.constraint(equalTo: fbLoginButton.trailingAnchor).isActive = true
        customFbLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
