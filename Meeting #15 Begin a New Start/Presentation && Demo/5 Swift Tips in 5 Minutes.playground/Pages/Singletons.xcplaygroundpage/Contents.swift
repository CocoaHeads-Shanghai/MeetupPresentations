//: [Previous](@previous)

//: It's thread-safe and lazily initialized.

import Foundation

class LocationManager {
    static let sharedManager = LocationManager()
    
    var city: String {
        return "Shanghai"
    }
}

LocationManager.sharedManager.city

//: [Next](@next)
