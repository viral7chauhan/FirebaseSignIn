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
import TwitterKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    // MARK: Stored properties
    lazy var fbLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.readPermissions = ["public_profile", "email"]
        button.delegate = self
        return button
    }()
    
    lazy var customFbLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Custom FB login", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleFBLoginClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var customGoogleSingInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Custom Google login", for: UIControlState.normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleGoogleLoginClick), for: .touchUpInside)
        return button
    }()
    
    let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var twitterLoginButton: TWTRLogInButton = {
        let logInButton =  TWTRLogInButton { (session, error) in
            if let err = error {
                print(err)
            }

            if let twtrsession = session {
                print(twtrsession)
                let token = twtrsession.authToken
                let secret = twtrsession.authTokenSecret
                let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let user = user {
                        print("Twitter user is login",user)
                        self.loginCompletion();
                    }
                }
            }
        }
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        return logInButton
    }()
    
    lazy var signUp: UIButton={
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    lazy var signIn: UIButton={
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        [fbLoginButton, customFbLoginButton, googleSignInButton, customGoogleSingInButton, twitterLoginButton, signUp, signIn].forEach{view.addSubview($0)}
        prepareButtons()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginCompletion();
    }
    
    //MARK: Target actions
    @objc func handleSignUp() {
        print("Press signup")
        self.performSegue(withIdentifier: "segue_ToSignUp", sender: nil)
    }
    
    @objc func handleSignIn() {
        print("Press signin")
        self.performSegue(withIdentifier: "segue_ToSignIn", sender: nil)
    }
    
    @objc func handleFBLoginClick (){
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            if let _ = response {
                print("Custom FB login successfully.")
                self.showEmailAddress()
            }
            
        }
    }
    
    @objc func handleGoogleLoginClick() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        
        if let user = user {
            print(user)
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let user = user {
                    print("Successfully login with firebase google" ,user)
                    self.loginCompletion();
                }
            }
        }
        
        
    }
    
    //MARK: FBSDKLoginButtonDelegate methods
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did you logout")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        
        if let _ = result.token {
            print("Login successfully")
            showEmailAddress()
        }
        
    }

    
    //MARK: Custom methods
    func loginCompletion() {
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "segue_ToHome", sender: user)
        } else {
            FBSDKLoginManager().logOut()
            GIDSignIn.sharedInstance().signOut()
        }
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
                self.loginCompletion();
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

// MARK: Extension
extension ViewController {
    
    func prepareButtons() {
        fbLoginButtons()
        googleButtons()
        twitterButtons()
        simpleLoginButtons()
    }
    fileprivate func simpleLoginButtons() {
        signUp.leadingAnchor.constraint(equalTo: fbLoginButton.leadingAnchor).isActive = true
        signUp.trailingAnchor.constraint(equalTo: fbLoginButton.trailingAnchor).isActive = true
        signUp.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUp.topAnchor.constraint(equalTo: twitterLoginButton.bottomAnchor, constant: 20).isActive = true
        
        signIn.leadingAnchor.constraint(equalTo: fbLoginButton.leadingAnchor).isActive = true
        signIn.trailingAnchor.constraint(equalTo: fbLoginButton.trailingAnchor).isActive = true
        signIn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signIn.topAnchor.constraint(equalTo: signUp.bottomAnchor, constant: 20).isActive = true
    }
    
    fileprivate func twitterButtons() {
       twitterLoginButton.leadingAnchor.constraint(equalTo: fbLoginButton.leadingAnchor).isActive = true
        twitterLoginButton.trailingAnchor.constraint(equalTo: fbLoginButton.trailingAnchor).isActive = true
        twitterLoginButton.heightAnchor.constraint(equalToConstant: 100)
        twitterLoginButton.topAnchor.constraint(equalTo: customGoogleSingInButton.bottomAnchor, constant: 20).isActive = true
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
