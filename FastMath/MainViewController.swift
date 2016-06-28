//
//  MainViewController.swift
//  FastMath
//
//  Created by Julio Franco on 6/28/16.
//  Copyright © 2016 Julio Franco. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var playMultiplayerButton: UIButton! {
        didSet {
            playMultiplayerButton.layer.borderWidth = 7
            playMultiplayerButton.layer.borderColor = UIColor(red: 79/255, green: 147/255, blue: 81/255, alpha: 1.0).CGColor
            playMultiplayerButton.layer.cornerRadius = 20
        }
    }
    
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}


