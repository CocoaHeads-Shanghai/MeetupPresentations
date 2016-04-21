//: [Previous](@previous)

import UIKit
import XCPlayground

/// - SeeAlso: [Reader Submissions - New Year's 2016](http://nshipster.com/new-years-2016/)
@warn_unused_result
public func Init<Type>(value : Type, @noescape block: (object: Type) -> Void) -> Type {
    block(object: value)
    return value
}

//: Good
let textLabel = Init(UILabel()) {
    $0.font = UIFont.boldSystemFontOfSize(13.0)
    $0.text = "Hello, World"
    $0.textAlignment = .Center
}

//: Not that good
let anotherLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFontOfSize(13.0)
    label.text = "Hello, World"
    label.textAlignment = .Center
    return label
}()

textLabel
anotherLabel

//: [Next](@next)
