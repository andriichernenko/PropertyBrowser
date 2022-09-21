//
//  Dimensions.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import Foundation

extension CGSize {
    
    static let normalImageAspectRatio = CGSize(width: 21, height: 9)
    
    static let highlightedImageAspectRatio = CGSize(width: 16, height: 9)
}

extension CGFloat {
    
    static let xSmall: CGFloat = 4
    
    static let small: CGFloat = 8
    
    static let medium: CGFloat = 16
    
    static let large: CGFloat = 32
    
    static let defaultPadding: CGFloat = .medium
}
