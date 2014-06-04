// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var optionValue : String? = "hello world"
optionValue = nil

if let x : String? = optionValue {
    "x is \(x)"
} else {
    "hi, i'm here"
}

if let x : String? = nil {
    "x is \(x)"
} else {
    "hi, i'm here"
}

optionValue = nil

if optionValue {
    "fuck "
} else {
    "shit"
}

