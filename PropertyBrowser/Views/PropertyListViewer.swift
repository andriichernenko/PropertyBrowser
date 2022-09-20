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
        ScrollView {
            switch viewModel.loadingState {
            case .loading:
                ProgressView {
                    Text("Loading…")
                        .style(.regularText)
                }
                .progressViewStyle(.circular)

            case .succeeded(let items):
                LazyVStack(alignment: .leading, spacing: 32) {
                    ForEach(items, id: \.id) {
                        _PropertyListItem(itemModel: $0)
                    }
                }
                
            case .failed:
                Text("Failed to load properties")
                    .style(.regularText)
                
            case .idle:
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
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
        VStack(alignment: .leading, spacing: 4) {
            switch itemModel.type {
            case let .area(_, name, rating, price):
                Text("Area")
                    .style(.secondaryTitle)
                
                Text(name)
                    .style(.importantText)
                                
                Text("Rating: \(rating)")
                    .style(.regularText)
                                            
                HStack {
                    Text("Average price: \(price)")
                        .style(.regularText)

                    Spacer()
                }

            case let .property(_, _, address, area, price, livingArea, roomCount):
                Text(address)
                    .style(.tertiaryTitle)
                
                Text(area)
                    .style(.secondaryText)
                                
                HStack(spacing: 4) {
                    Text(price)
                        .style(.importantText)

                    Spacer()
                    
                    Text(livingArea)
                        .style(.importantText)

                    Spacer()
                    
                    Text(roomCount)
                        .style(.importantText)
                }
            }
        }
    }
}
