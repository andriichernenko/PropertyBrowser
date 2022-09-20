//
//  LoadingState.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import Foundation

enum LoadingState<Value> {
    case idle
    case loading
    case succeeded(value: Value)
    case failed(error: Error)
}
