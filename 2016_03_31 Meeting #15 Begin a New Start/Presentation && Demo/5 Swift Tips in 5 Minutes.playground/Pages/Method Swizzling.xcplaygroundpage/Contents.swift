//: [Previous](@previous)

//: # Method Swizzling
//: Method swizzling is replacing one method implementation with another. Marking with the `dynamic`modifier makes
//: them always dynamic dispatched using the Objective-C runtime.


import Foundation

/// - Author: Nathan Hillyer
/// - SeeAlso: [15 Tips to Become a Better Swift Developer](http://savvyapps.com/blog/swift-tips-for-developers)
class AwesomeClass {
    dynamic func originalFunction() -> String {
        return "originalFunction"
    }
    
    dynamic func swizzledFunction() -> String {
        return "swizzledFunction"
    }
}

let awesomeObject = AwesomeClass()

print(awesomeObject.originalFunction()) // prints: "originalFunction"

let aClass = AwesomeClass.self
let originalMethod = class_getInstanceMethod(aClass, #selector(AwesomeClass.originalFunction))
let swizzledMethod = class_getInstanceMethod(aClass, #selector(AwesomeClass.swizzledFunction))
method_exchangeImplementations(originalMethod, swizzledMethod)

print(awesomeObject.originalFunction())  // prints: "swizzledFunction"

//: [Next](@next)
