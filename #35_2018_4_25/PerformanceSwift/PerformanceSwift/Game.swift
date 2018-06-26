//
//  Game.swift
//  PerformanceSwift
//
//  Created by Phink on 4/24/18.
//  Copyright © 2018 Senten Sarl. All rights reserved.
//

import Foundation

public protocol Pingable { func ping() -> Self }
public protocol Playable { func play() -> Int}

extension Int : Pingable {
    public func ping () -> Int { return self + 1 }
}

public class Game<T : Pingable> : Playable {
    var t : T
    public init (_ v: T) { t = v }
    
//    @_specialize (exported: true, where T == Int)
    public func play () -> Int {
        for _ in 0 ... 100_000_000 { t = t.ping() }
        return 1
    }
}
