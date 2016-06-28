//
//  FastMathViewController.swift
//  FastMath
//
//  Created by Julio Franco on 6/27/16.
//  Copyright © 2016 Julio Franco. All rights reserved.
//

import UIKit
import Firebase

class FastMathViewController: UIViewController {
    
    lazy var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var gameRef: FIRDatabaseReference!
    let mathProblemPath = "math"
    
    var refHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameRef = ref.child(mathProblemPath)
        
        refHandle = gameRef.observeEventType(.Value, withBlock: { (snapshot) in
            print("some value changed")
            print(snapshot.childrenCount)
            print(snapshot.childSnapshotForPath("op1"))
            let val = snapshot.childSnapshotForPath("op1").value as! Int
            self.thirdbttnlabel.setTitle(String(val), forState: .Normal)
        })
        
        let mathProblem = MathProblem()
        print(mathProblem.result)
        mathProblem.updateValues(8, op2: 2, operation: "+")
        print(mathProblem.result)
        
        
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user, error) in
            if error != nil {
                print(error!.description)
                return
            } else {
                print("authenticated \(user!.uid)")
            }
        })
    }

    @IBAction func firstbutton(sender: AnyObject) {
        ref.child("math").child("op1").setValue(69)
        
    }

    @IBAction func secondbutton(sender: AnyObject) {
    }
    
    @IBAction func thridbutton(sender: AnyObject) {
    }
    @IBOutlet weak var thirdbttnlabel: UIButton!
}

