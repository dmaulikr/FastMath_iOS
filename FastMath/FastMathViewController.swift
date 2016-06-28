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
            resultTextView.becomeFirstResponder()
            // Also changes the color of the blinking cursor
            UITextView.appearance().tintColor = UIColor(red: 238/255, green: 232/255, blue: 199/255, alpha: 1.0)
        }
    }
    
    var mathProblem = MathProblem()
    var newMathProblem: (op1: Int, op2: Int, opt: String)! {
        didSet {
            firstOperandLabel.text = String(newMathProblem.op1)
            operationLabel.text = newMathProblem.opt
            secondOperandLabel.text = String(newMathProblem.op2)
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
            let val1 = snapshot.childSnapshotForPath("op1").value as! Int
            let val2 = snapshot.childSnapshotForPath("op2").value as! Int
            let val3 = snapshot.childSnapshotForPath("operation").value as! String
            self.mathProblem.updateValues(val1, op2: val2, operation: val3)
            self.newMathProblem = (val1, val2, val3)
        })

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
    
    func updateFIRMathProblem() {
        let values:[String : AnyObject] = [
            "op1": newMathProblem.op1,
            "op2": newMathProblem.op2,
            "operation": newMathProblem.opt
        ]
        ref.child(mathProblemPath).setValue(values)
    }
    
    // Executes code in closure after delay (seconds)
    func delay(delay:Double, closure:()->()) {
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    
}

extension FastMathViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        if mathProblem.result == Int(textView.text) {
            delay(0.15) { textView.text = "" }
            newMathProblem = mathProblem.generateValues()
            updateFIRMathProblem()
            print("The new result is \(mathProblem.result)")
        } else {
            let length = textView.text.characters.count
            if length == 3 {
                textView.shake()
                delay(0.3) { textView.text = "" }
            } else if length > 3 {
                // Drops the last characters, giving the effect that only 3 chars are allowed
                textView.text = String(textView.text.characters.dropLast())
            }
        }
    }
    
}

extension UIView {
    // Shake animation used on wrong answer
    // http://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.4
        animation.values = [-15.0, 15.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
}


