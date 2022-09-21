//
//  PropertyDetailPlaceholder.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import UIKit
import SwiftUI

class PropertyDetailPlaceholder: UIHostingController<_PropertyDetailPlaceholder> {
    
    init() {
        super.init(rootView: .init())
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

struct _PropertyDetailPlaceholder: View {

    var body: some View {
        VStack {
            // TODO: Localize
            Text("Please select a property from the list")
                .style(.regularText)
        }
        .padding(.defaultPadding)
    }
}

struct _PropertyDetailPlaceholder_Previews: PreviewProvider {
        
    static var previews: some View {
        _PropertyDetailPlaceholder()
    }
}

