//
//  ViewController.swift
//  FastMath
//
//  Created by Julio Franco on 6/27/16.
//  Copyright © 2016 Julio Franco. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user, error) in
            if error != nil {
                print(error!.description)
                return
            } else {
                print("authenticated \(user!.uid)")
            }
        })
    }


}

