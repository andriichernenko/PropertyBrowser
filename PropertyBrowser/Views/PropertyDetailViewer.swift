//
//  PropertyDetailViewer.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import Foundation
import SwiftUI
import Combine

class PropertyDetailViewer: UIHostingController<_PropertyDetailViewer> {
    
    init(item: PropertyList.Item, propertyService: PropertyService) {
        super.init(rootView: .init(viewModel: .init(
            item: item,
            propertyService: propertyService
        )))
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        // TODO: Localize
        title = "Property details"
    }
}

struct _PropertyDetailViewer: View {

    @StateObject var viewModel: PropertyDetailViewer.ViewModel
        
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

            case .succeeded(let details):
                ScrollView {
                    VStack(alignment: .leading) {
                        AsyncImage(
                            url: details.imageURL,
                            aspectRatio: details.imageIsHighlighted ? .highlightedImageAspectRatio : .normalImageAspectRatio
                        )
                        
                        Spacer(minLength: 16)
                        
                        Text(details.streetAddress)
                            .style(.primaryTitle)

                        Text(details.areaInfo)
                            .style(.secondaryText)

                        Text(details.askingPrice)
                            .style(.tertiaryTitle)

                        Spacer(minLength: 16)
                        
                        Text(details.description)
                            .style(.regularText)
                        
                        Spacer(minLength: 16)
                        
                        ForEach([
                            ("Living area:", details.livingArea),
                            ("Number of rooms:", details.roomCount),
                            ("Patio:", details.patio),
                            ("Days since publish:", details.daysSincePublishing),
                        ], id: \.0) { (label, data) in
                            HStack(spacing: 4) {
                                Text(label)
                                    .style(.importantText)

                                Text(data)
                                    .style(.regularText)
                            }

                            Spacer(minLength: 4)
                        }
                    }
                }
                
            case .failed:
                Text("Failed to load property details")
                    .style(.regularText)

            case .idle:
                Spacer()
            }
        }
        .padding(16)
        .onAppear { viewModel.viewDidAppear() }
    }
}

struct _PropertyDetailViewer_Previews: PreviewProvider {
        
    static var previews: some View {
        _PropertyDetailViewer(
            viewModel: .init(
                item: mockPropertyItem,
                propertyService: MockPropertyService(details: mockPropertyDetails)
            )
        )
    }
}
