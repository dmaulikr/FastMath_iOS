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
    
    @IBOutlet weak var firstOperandLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var secondOperandLabel: UILabel!
    
    @IBOutlet weak var resultTextView: UITextView! {
        didSet {
            resultTextView.delegate = self
            resultTextView.layer.cornerRadius = 10.0
        }
    }
    
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
        resultTextView.shake()
    }
    @IBOutlet weak var thirdbttnlabel: UIButton!
}

extension FastMathViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        // check if answer is correct
        
        let length = textView.text.characters.count
        if length == 3 {
            // Only a max of three numbers is allowed
            // Indicate answer is wrong by shaking textView and empty answer
            
            // shake textview duration 0.75, on completion clear out text
            textView.text = ""
        }
        print("textview changed")
    }

}


extension UIView {
    // http://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.4
        animation.values = [-15.0, 15.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
}



