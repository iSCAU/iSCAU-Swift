// Playground - noun: a place where people can play

import Cocoa

//var str = "Hello, playground"
//
//var optionValue : String? = "hello world"
//
//var tag = 11
//
///////////////////////
//var ten: Int = 10
//var string: String = "string"
//var pi: Double = 3.14
//var pi_2: Float = 3.14 / 2
//var array: Array<Int> = Int[](count: 10, repeatedValue: 10)
//var literalArray = [5, 5, 5, 5]
//var dict: Dictionary<String, Int> = [ "key" : 10 ]
//var literalDict = [ "key": 10 ]
//
///////////////////////
//class bar {
//    let bar: String?
//}
//
//class foo : bar  {
//    
//    class func bar(param1: String, inout theParam2 param2 : Int, var param3: Bool) {
////        param1 = ""
//        param2 = 3
//        param3 = false
//        
//        return
//    }
//    
//    func foo(#string: String, char1: Character = "a", char2: Character = "b") -> String {
//        return string + char1 + char2
//    }
//}
//
//var test = 2
//foo.bar("param1", theParam2: &test, param3: true) // 第一个参数
//test
//
//var methodPointer : ((String, Character, Character) -> String)?
//
//var bar1 = foo()
//bar1.foo(string: "string")
//
///////////////////
//
//var one = 1
//var twoPointFour = 2.4
//let three = one  + Int(twoPointFour)
//var threePointFour = Double(one) + twoPointFour
////threePointFour = 5
////var overflow = 4294967296 * 4294967296 // 2 ^ 64
//
///////////////////
//enum enumation {
//    case one
//    case two
//    case three
//}
//
//var e = enumation.two
//var result = "result is: "
//switch e {
//case .one:
//    result += "one"
//    println("one")
//case .two, .three:
//    result += "two"
//    println("two")
////case .three:
////    result += "three"
////    println("three")
//}
//var so = result
//
/////////////////
//
////func stringFunc(string: String) -> String -> String {
////    return func abc (str: String) -> String {
////        return ""
////    }
////}
////
////func justForFun(string: String) -> String -> String {
////    return stringFunc("str")
////}
//
/////////////////
//
//func funcThatTakesClosure(closure: () -> ()) {
//    let abc = "ecd"
//    closure()
//}
//
//funcThatTakesClosure {
//    let a = "ab"
//    println("abc")
//}
//
/////////////////
//
//func makeIncrementor(forIncrement amout: Int) -> () -> Int {
//    var runningTotal = 1
//    func incrementor() -> Int {
//        runningTotal += amout
//        println(runningTotal)
//        return runningTotal
//    }
//    return incrementor
//}
//
//var incrementor =   makeIncrementor(forIncrement: 4)
//var incrementor2 = makeIncrementor(forIncrement: 2)
//incrementor()
//incrementor()
//incrementor()
//incrementor()
//incrementor()
//incrementor()
//incrementor()
//let cd = incrementor()
//incrementor()
//incrementor()
//incrementor2()
//
//println(cd)
//
//
//var color = UIColor.red


let storeName = "iSCAUSwift"
let soreSqliteName = "\(storeName).sqlite"

func add1() -> (Int -> ((Int, Int) -> Int)) {
    func addOne(a: Int) -> ((Int, Int) -> Int) {
        func addOneTwo(a: Int, b: Int) -> Int {
            return a + b
        }
        return addOneTwo
    }
    return addOne
}


add1()(1)(1, 2)
