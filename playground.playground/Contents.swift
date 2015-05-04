//: Playground - noun: a place where people can play

import UIKit

func incrementer()->(Int->Int) {
    
    func addOne(number:Int)->Int {
        return number + 1
    }
    return addOne
}

var increment = incrementer()

increment(4)
