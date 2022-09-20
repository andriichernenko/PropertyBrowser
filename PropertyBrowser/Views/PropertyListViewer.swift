//
//  PropertyListViewer.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import UIKit
import SwiftUI
import Combine

class PropertyListViewer: UIHostingController<_PropertyListViewer> {
    
    init(propertyService: PropertyService) {
        super.init(rootView: .init(viewModel: .init(propertyService: propertyService)))
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        // TODO: Localize
        title = "Property list"
    }
}

struct _PropertyListViewer: View {

    @StateObject var viewModel: PropertyListViewer.ViewModel
    
    var body: some View {
        // TODO: Localize
        List {
            switch viewModel.loadingState {
            case .loading:
                ProgressView("Loading…")
                    .progressViewStyle(.circular)

            case .succeeded(let items):
                ForEach(items, id: \.id) {
                    _PropertyListItem(itemModel: $0)
                }
                
            case .failed:
                Text("Failed to load properties")
                
            case .idle:
                Spacer()
            }
        }
        .listStyle(PlainListStyle())
        .frame(maxWidth: .infinity)
        .onAppear { viewModel.viewDidAppear() }
    }
}

struct _PropertyListViewer_Previews: PreviewProvider {
        
    static var previews: some View {
        _PropertyListViewer(
            viewModel: .init(propertyService: MockPropertyService(list: mockPropertyList))
        )
    }
}

struct _PropertyListItem: View {
    let itemModel: PropertyListViewer.ItemModel
    
    var body: some View {
        VStack {
            switch itemModel.type {
            case .area:
                Text("Area: \(itemModel.id)")
            
            case .property:
                Text("Property: \(itemModel.id)")
            }
        }
        .background(Color.yellow)
    }
}
