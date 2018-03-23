//
//  Home.swift
//  FirebaseSocialLogin
//
//  Created by Falguni Viral Chauhan on 22/03/18.
//  Copyright © 2018 Falguni Viral Chauhan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Home : UIViewController {
    
    @IBAction func Logout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
