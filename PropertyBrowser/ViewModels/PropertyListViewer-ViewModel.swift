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
        
        @Published var loadingState: LoadingState<[ItemModel]> = .idle
        
        init(propertyService: PropertyService) {
            self.propertyService = propertyService
        }
        
        func viewDidAppear() {
            loadingState = .loading
            
            Task {
                do {
                    let listItems = try await propertyService
                        .fetchPropertyList()
                        .items
                        .map { ItemModel(item: $0) }
                                        
                    await MainActor.run { loadingState = .succeeded(value: listItems) }
                } catch {
                    await MainActor.run { loadingState = .failed(error: error) }
                }
            }
        }
    }
    
    struct ItemModel {
        let id: String
        let type: `Type`
        
        enum `Type` {
            case property(
                imageURL: URL,
                imageIsHighlighted: Bool,
                streetAddressDescription: String,
                areaDescription: String,
                priceDescription: String,
                livingAreaDescription: String,
                roomCountDescription: String
            )

            case area(
                imageURL: URL,
                name: String,
                ratingDescription: String,
                averagePriceDescription: String
            )
        }
        
        init(item: PropertyList.Item) {
            self.id = item.id.rawValue

            switch item.attributes {
            
            case .property(let propertyAttributes):
                self.type = .property(
                    imageURL: item.imageURL,
                    imageIsHighlighted: item.type == .highlightedProperty,
                    streetAddressDescription: propertyAttributes.streetAddress,
                    areaDescription: "\(propertyAttributes.area), \(propertyAttributes.municipality)",
                    priceDescription: "\(propertyAttributes.askingPrice) SEK",
                    livingAreaDescription: "\(propertyAttributes.livingArea) m²",
                    roomCountDescription: "\(propertyAttributes.numberOfRooms) rooms"
                )
                
            case .area(let areaAttributes):
                self.type = .area(
                    imageURL: item.imageURL,
                    name: areaAttributes.name,
                    ratingDescription: areaAttributes.ratingFormatted,
                    averagePriceDescription: "\(areaAttributes.averagePrice) SEK"
                )
            }
        }
    }
}
