//
//  MemoryAccess.swift
//  PerformanceSwiftTests
//
//  Created by Phink on 4/24/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

import XCTest

let size = 2500

class MemoryAccess: XCTestCase {
    
    var array = Array(repeating: Array(repeating: 0.0, count: size), count: size)
    
    func loopCon () -> Double {
        var sum = 0.0
        for i in 0 ..< size {
            for j in 0 ..< size {
                array[i][j] = Double(i)
                sum += array[i][j]
            }
        }
        return sum
    }

    func loopDis () -> Double {
        var sum = 0.0
        for j in 0 ..< size {
            for i in 0 ..< size {
                array[i][j] = Double(i)
                sum += array[i][j]
            }
        }
        return sum
    }
    
    func testContiguous () {
        self.measure {
            print (self.loopCon())
        }
    }

    func testDiscontiguous () {
        self.measure {
            print (self.loopDis())
        }
    }

}
