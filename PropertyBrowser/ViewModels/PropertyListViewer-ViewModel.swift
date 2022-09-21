//
//  PropertyList.ViewModel.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import Foundation
import Combine

extension PropertyListViewer {
    typealias SelectItem = (PropertyList.Item) -> Void

    class ViewModel: ObservableObject {
        
        private let didSelectItem: SelectItem
        private let propertyService: PropertyService

        @Published var state: LoadingState<[ItemModel]> = .idle
        @Published private(set) var selectedPropertyItem: PropertyList.Item? = nil
        
        init(didSelectItem: @escaping SelectItem, propertyService: PropertyService) {
            self.didSelectItem = didSelectItem
            self.propertyService = propertyService
        }
        
        func viewDidAppear() {
            state = .loading
            selectedPropertyItem = nil
            
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

        func isSelected(_ item: ItemModel) -> Bool {
            return item.propertyItem == selectedPropertyItem
        }
        
        func didTapListItem(_ item: ItemModel) {
            guard case .succeeded(let items) = state else {
                return
            }

            if items.first == item {
                selectedPropertyItem = item.propertyItem
                didSelectItem(item.propertyItem)
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
                    priceDescription: "\(propertyAttributes.askingPrice) SEK",
                    livingAreaDescription: "\(propertyAttributes.livingArea) m²",
                    roomCountDescription: "\(propertyAttributes.numberOfRooms) rooms"
                )
                
            case .area(let areaAttributes):
                self.type = .area(
                    name: areaAttributes.name,
                    ratingDescription: areaAttributes.ratingFormatted,
                    averagePriceDescription: "\(areaAttributes.averagePrice) SEK"
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
