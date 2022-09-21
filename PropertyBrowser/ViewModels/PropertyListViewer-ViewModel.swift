//
//  PropertyList.ViewModel.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import Foundation
import Combine

extension PropertyListViewer {
    typealias SelectItem = any Subject<PropertyList.Item?, Never>

    class ViewModel: ObservableObject {

        private let propertyService: PropertyService
        private var selectItemSubscription: AnyCancellable?

        @Published var state: State<[ItemModel]> = .idle
        @Published private(set) var selectedPropertyItem: PropertyList.Item? = nil
        
        init(selectItem: SelectItem? = nil, propertyService: PropertyService) {
            self.propertyService = propertyService
            
            if let selectItem {
                self.selectItemSubscription = $selectedPropertyItem
                    .subscribe(selectItem)
            }
        }
        
        func viewDidAppear() {
            state = .loading
            
            Task {
                do {
                    let listItems = try await propertyService
                        .fetchPropertyList()
                        .items
                        .map { ItemModel(item: $0) }
                                        
                    await MainActor.run { state = .succeeded(value: listItems) }
                } catch {
                    await MainActor.run { state = .failed(error: error) }
                }
            }
        }

        func isSelected(_ item: PropertyList.Item) -> Bool {
            return item == selectedPropertyItem
        }
        
        func didTapListItem(_ item: PropertyList.Item) {
            guard case .succeeded(let items) = state else {
                return
            }

            if items.first?.propertyItem == item {
                selectedPropertyItem = item
            }
        }
    }
    
    struct ItemModel: Equatable {
        let propertyItem: PropertyList.Item
        
        let id: String
        let imageURL: URL
        let type: `Type`
        
        init(item: PropertyList.Item) {
            self.propertyItem = item
            
            self.id = item.id.rawValue
            self.imageURL = item.imageURL

            switch item.attributes {
            
            case .property(let propertyAttributes):
                self.type = .property(
                    imageIsHighlighted: item.type == .highlightedProperty,
                    streetAddressDescription: propertyAttributes.streetAddress,
                    areaDescription: "\(propertyAttributes.area), \(propertyAttributes.municipality)",
                    priceDescription: propertyAttributes.askingPrice.formatted,
                    livingAreaDescription: "\(propertyAttributes.livingArea) m²",
                    roomCountDescription: "\(propertyAttributes.numberOfRooms) rooms"
                )
                
            case .area(let areaAttributes):
                self.type = .area(
                    name: areaAttributes.name,
                    ratingDescription: areaAttributes.ratingFormatted,
                    averagePriceDescription: areaAttributes.averagePrice.formatted
                )
            }
        }
        
        enum `Type`: Equatable {
            case property(
                imageIsHighlighted: Bool,
                streetAddressDescription: String,
                areaDescription: String,
                priceDescription: String,
                livingAreaDescription: String,
                roomCountDescription: String
            )

            case area(
                name: String,
                ratingDescription: String,
                averagePriceDescription: String
            )
        }
    }
}
