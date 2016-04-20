//: [Previous](@previous)

//: [Swift: Selector syntax sugar](https://medium.com/swift-programming/swift-selector-syntax-sugar-81c8a8b10df3#.e765rew0v) by Andyy Hope

import UIKit
import XCPlayground

class ViewController: UIViewController {
    private struct Action {
        static let buttonTapped =
            #selector(ViewController.buttonTapped(_:))
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap", forState: .Normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        button.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
//        button.addTarget(self, action: #selector(ViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        button.addTarget(self, action: Action.buttonTapped, forControlEvents: .TouchUpInside)
    }
    
    func buttonTapped(sender: UIButton) {
        print("Tapped")
    }
}

let viewController = ViewController()
XCPlaygroundPage.currentPage.liveView = viewController

//: [Next](@next)
