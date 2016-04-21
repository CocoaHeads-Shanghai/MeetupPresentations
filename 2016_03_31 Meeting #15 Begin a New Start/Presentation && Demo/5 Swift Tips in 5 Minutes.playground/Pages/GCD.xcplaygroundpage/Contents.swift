//: [Previous](@previous)

import Foundation

enum Queue {
    case main
    case userInteractive
    case userInitiated
    case defaults
    case utility
    case background
    case serial(String)
    case concurrent(String)
    
    var dispatchQueue: dispatch_queue_t {
        switch self {
        case .main:
            return dispatch_get_main_queue()
        case .userInteractive:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        case .userInitiated:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        case .defaults:
            return dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
        case .utility:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        case .background:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        case .serial(let string):
            return dispatch_queue_create(string, DISPATCH_QUEUE_SERIAL)
        case .concurrent(let string):
            return dispatch_queue_create(string, DISPATCH_QUEUE_CONCURRENT)
        }
    }
}

func async(queue: Queue = .main, _ block: dispatch_block_t) {
    dispatch_async(queue.dispatchQueue, block)
}

func delay(seconds: Double, queue: Queue = .main, _ block: dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), queue.dispatchQueue, block)
}

delay(2.0, queue: .utility) {
    // Do something...
    async() {
        // DO something else...
    }
}

//: [Next](@next)
