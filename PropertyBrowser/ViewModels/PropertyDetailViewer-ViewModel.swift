//
//  PropertyDetailViewer-ViewModel.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import Foundation
import Combine

extension PropertyDetailViewer {
    
    class ViewModel: ObservableObject {
        private let item: PropertyList.Item
        private let propertyService: PropertyService

        @Published var state: State<FormattedPropertyDetails> = .idle
        
        init(item: PropertyList.Item, propertyService: PropertyService) {
            self.item = item
            self.propertyService = propertyService
        }
        
        func viewDidAppear() {
            state = .loading
            
            Task {
                do {
                    let details = try await propertyService.fetchDetails(for: item)
                    await MainActor.run { state = .succeeded(value: .init(propertyDetails: details)) }
                } catch {
                    await MainActor.run { state = .failed(error: error) }
                }
            }
        }
    }
}

struct FormattedPropertyDetails {
    let imageURL: URL
    let imageIsHighlighted: Bool
    
    let streetAddress: String
    let areaInfo: String
    let askingPrice: String
    let description: String
    let livingArea: String
    let roomCount: String
    let patio: String
    let daysSincePublishing: String
    
    init(propertyDetails: PropertyDetails) {
        self.imageURL = propertyDetails.imageURL
        self.imageIsHighlighted = propertyDetails.type == .highlightedProperty
        
        self.streetAddress = propertyDetails.streetAddress
        self.askingPrice = propertyDetails.askingPrice.formatted
        self.areaInfo = "\(propertyDetails.area), \(propertyDetails.municipality)"
        self.description = propertyDetails.description
        self.livingArea = "\(propertyDetails.livingArea) m²"
        self.roomCount = "\(propertyDetails.numberOfRooms)"
        self.patio = "\(propertyDetails.patio.rawValue)"
        self.daysSincePublishing = "\(propertyDetails.daysSincePublishing)"
    }
}
