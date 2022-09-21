//
//  PropertyListViewer.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import Foundation
import SwiftUI
import Combine

class PropertyListViewer: UIHostingController<_PropertyListViewer> {
    
    init(selectItem: SelectItem, propertyService: PropertyService) {
        super.init(rootView: .init(
            viewModel: .init(selectItem: selectItem, propertyService: propertyService)
        ))
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
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView {
                    Text("Loading…")
                        .style(.regularText)
                }
                .progressViewStyle(.circular)

            case .succeeded(let items):
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(items, id: \.id) { listItem in
                            PropertyListItem(
                                itemModel: listItem,
                                isSelected: viewModel.isSelected(listItem)
                            )
                            .onTapGesture { viewModel.didTapListItem(listItem) }
                        }
                    }
                }

            case .failed:
                Text("Failed to load properties")
                    .style(.regularText)

            case .idle:
                Spacer()
            }
        }
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

struct PropertyListItem: View {
    var itemModel: PropertyListViewer.ItemModel
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            switch itemModel.type {
            case let .area(name, rating, price):
                Text("Area")
                    .style(.secondaryTitle)

                Spacer(minLength: 8)
                
                AsyncImage(
                    url: itemModel.imageURL,
                    aspectRatio: .normalImageAspectRatio
                )
                
                Spacer(minLength: 8)
                
                Text(name)
                    .style(.importantText)

                Text("Rating: \(rating)")
                    .style(.regularText)

                HStack {
                    Text("Average price: \(price)")
                        .style(.regularText)

                    Spacer()
                }

            case let .property(imageIsHighlighted, address, area, price, livingArea, roomCount):
                AsyncImage(
                    url: itemModel.imageURL,
                    aspectRatio: imageIsHighlighted ? .highlightedImageAspectRatio : .normalImageAspectRatio
                )
                .border(Color.imageHighlight, width: imageIsHighlighted ? 4 : 0)
                
                Spacer(minLength: 8)
                
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
        .padding(16)
        .background(isSelected ? Color.selectedCellBackground : Color.background)
    }
}
