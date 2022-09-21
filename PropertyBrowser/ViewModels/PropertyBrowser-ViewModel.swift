//
//  PropertyBrowser-ViewModel.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import Combine

extension PropertyBrowser {
    
    class ViewModel {
        
        var selectedPropertyItem: CurrentValueSubject<PropertyList.Item?, Never> = .init(nil)
        
        var hasSelection: Bool { selectedPropertyItem.value != nil }
    }
}
