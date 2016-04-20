//: [Previous](@previous)

//: [Safely invoking removeAtIndex](http://ericasadun.com/2016/03/14/safely-invoking-removeatindex/) by Erica Sadun

import UIKit

let image = [#Image(imageLiteral: "Screen Shot 2016-03-27 at 11.01.00.png")#]
image

public extension RangeReplaceableCollectionType where Index: Comparable {
    public subscript (safe index: Index) -> Generator.Element? {
        get {
            guard indices ~= index else { return nil }
            return self[index]
        }
        set {
            guard indices ~= index else { return }
            if let newValue = newValue {
                self.removeAtIndex(index)
                self.insert(newValue, atIndex: index)
            }
        }
    }
    
    public mutating func removeAtIndex(safe index: Self.Index) -> Self.Generator.Element? {
        guard indices ~= index else { return nil}
        return self.removeAtIndex(index)
    }
}

let array = [0, 1, 2, 3, 4, 5]

array[5]
//array[7]

array[safe: 5]
array[safe: 7]

//: [Next](@next)
