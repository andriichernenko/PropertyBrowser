//
//  State.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import Foundation

enum State<Value> {
    case idle
    case loading
    case succeeded(value: Value)
    case failed(error: Error)
}

extension State: Equatable where Value: Equatable {
    
    static func == (lhs: State<Value>, rhs: State<Value>) -> Bool {
        switch (lhs, rhs) {
        case let (.succeeded(lhsValue), .succeeded(rhsValue)):
            return lhsValue == rhsValue
            
        case (.idle, .idle), (.loading, .loading), (.failed, .failed):
            return true
            
        default:
            return false
        }
    }
}
