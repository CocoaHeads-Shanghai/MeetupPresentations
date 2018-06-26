//
//  MapVsLoop.swift
//  PerformanceSwiftTests
//
//  Created by Phink on 4/24/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

import XCTest

class MapVsLoop: XCTestCase {
    
    var array = [Float](repeating: 0, count: 10_000_000)
    
    override func setUp() {
        super.setUp()
        for i in 0..<array.count {
            array[i] = Float(arc4random())
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func useMap () {
        var output = array.map({ (element) -> Float in
            return element * 5
        })
        print (output[13])
    }
    
    func useForLoop () {
        var output = [Float]()
        output.reserveCapacity(array.count)
        for element in array {
            output.append(element * 5)
        }
        print (output[13])
    }
    
    func testMap () {
        self.measure {
            self.useMap()
        }
    }
    
    func testLoop () {
        self.measure {
            self.useForLoop()
        }
    }
}
