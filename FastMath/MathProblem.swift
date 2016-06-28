//
//  MathProblem.swift
//  FastMath
//
//  Created by Julio Franco on 6/27/16.
//  Copyright © 2016 Julio Franco. All rights reserved.
//

import Foundation

class MathProblem {
    
    private var operand1 = 0
    private var operand2 = 0
    private var operation = ""
    var result = 0
    
    private enum Operation {
        case BinaryOperation((Int, Int) -> Int)
    }
    
    private var math = [
        "+": Operation.BinaryOperation(+),
        "−": Operation.BinaryOperation(-)
    ]
    
    private func performOperation() -> Int {
        if let operation = math[operation] {
            switch operation {
            case .BinaryOperation(let function):
                return function(operand1, operand2)
            }
        } else {
            return 0
        }
    }
    
    func updateValues(op1: Int, op2: Int, operation op: String) {
        operand1 = op1
        operand2 = op2
        operation = op
        result = performOperation()
    }
    
    func generateValues() -> (op1: Int, op2: Int, opt: String) {
        let rand1 = Int(arc4random_uniform(100)) + 1 // range [1,100]
        var rand2: Int!
        let randOpers = Int(arc4random_uniform(2)) // Random 0 or 1
        let opers = ["+","−"]
        
        if opers[randOpers] == "−" {
            // Doesn't allow a negative result
            rand2 = Int(arc4random_uniform(UInt32(rand1))) + 1 // range [1, rand1]
        } else {
            rand2 = Int(arc4random_uniform(100)) + 1 // range [1,100]
        }
        
        updateValues(rand1, op2: rand2, operation: opers[randOpers])
        return (rand1, rand2, opers[randOpers])
    }
    
}


