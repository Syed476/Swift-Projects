//: [Previous](@previous)

import Foundation


func main() {
    class Temp {
        var t:Double
        init () {
            t = 10.0
        }
    }
    class Emp {
        var sal : Int
        init (sal:Int){
            self.sal = sal
        }
        func salEmp(){
            print ("the manager salary is \(sal)")
        }
    }
    class Calc {
        let a: Int
        let b: Int
        let c: Int
        
        init(a: Int, b: Int) {
            self.a = a
            self.b = b
            self.c = a + b  // Fixed: added self.
        }
        
        func total(cc: Int) -> Int {
            return (c - cc)
        }
        
        func result() {
            print("result: \(total(cc: 40))")  // Fixed: proper string interpolation
            print("result: \(total(cc: 20))")  // Fixed: proper string interpolation
        }
    }

    var calc = Calc(a: 300, b: 200)  // Fixed: variable name follows convention
    calc.result()
    var E = Emp(sal: 49000)
    E.salEmp()
    var my_t = Temp()
    print ("the default temp of city is  \(my_t.t)")
}

main()
