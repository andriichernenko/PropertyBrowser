//
//  PropertyList.ViewModel.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import Foundation
import Combine

extension PropertyListViewer {
    
    class ViewModel: ObservableObject {
        private let propertyService: PropertyService

        @Published var state: LoadingState<[ItemModel]> = .idle
        
        init(propertyService: PropertyService) {
            self.propertyService = propertyService
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
    }
    
    class ItemModel {
        let id: String
        let imageURL: URL
        let type: `Type`
        
        init(item: PropertyList.Item) {
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
        
        enum `Type` {
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
