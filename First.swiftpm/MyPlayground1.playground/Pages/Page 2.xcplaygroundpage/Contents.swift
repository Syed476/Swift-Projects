//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

func perform (operation:String,on a:Double, and b:Double) -> Double {
    print ("performing",operation,"on",a,"and",b)
    var result:Double = 0
    switch operation {
        case "+":
            result = a + b
        case "-":
            result = a - b
        case "*":
            result = a * b
        case "/":
            result = a / b
        default: "invalid operation"
    }
    return result
}
let result = perform(operation: "+", on: 10, and: 20)
