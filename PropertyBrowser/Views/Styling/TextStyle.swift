//
//  TextStyle.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import SwiftUI

enum TextStyle {
    case primaryTitle
    case secondaryTitle
    case tertiaryTitle
    
    case regularText
    case importantText
    case secondaryText
}

extension Text {
    
    func style(_ style: TextStyle) -> Text {
        switch style {
        case .primaryTitle:
            return self
                .font(.system(.title, design: .serif))
                .foregroundColor(.primaryText)
                .bold()
        
        case .secondaryTitle:
            return self
                .font(.title2)
                .foregroundColor(.primaryText)
                .bold()
        
        case .tertiaryTitle:
            return self
                .font(.title3)
                .foregroundColor(.primaryText)
                .bold()
        
        case .regularText:
            return self
                .font(.body)
                .foregroundColor(.primaryText)
        
        case .importantText:
            return self
                .font(.body)
                .foregroundColor(.primaryText)
                .bold()
        
        case .secondaryText:
            return self
                .font(.body)
                .foregroundColor(.secondaryText)
        }
    }
}
