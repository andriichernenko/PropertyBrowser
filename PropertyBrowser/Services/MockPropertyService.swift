//
//  MockPropertyService.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

class MockPropertyService: PropertyService {
    private let list: PropertyList
    private let details: PropertyDetails
    
    init(list: PropertyList = mockPropertyList, details: PropertyDetails = mockPropertyDetails) {
        self.list = list
        self.details = details
    }
    
    func fetchPropertyList() async throws -> PropertyList {
        return list
    }
    
    func fetchDetails(for: PropertyList.Item) async throws -> PropertyDetails {
        return details
    }
}

let mockPropertyItem = PropertyList.Item(
    id: .init(rawValue: "1234567893"),
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Bertha_Petterssons_hus_01.jpg/800px-Bertha_Petterssons_hus_01.jpg")!,
    type: .highlightedProperty,
    attributes: .property(.init(
        daysSincePublishing: 12,
        askingPrice: 1150000,
        livingArea: 29,
        numberOfRooms: 1,
        monthlyFee: 2298,
        streetAddress: "Mockvägen 4",
        area: "Kvarngärdet",
        municipality: "Uppsala kommun"
    ))
)

let mockAreaItem = PropertyList.Item(
    id: .init(rawValue: "1234567896"),
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Bertha_Petterssons_hus_01.jpg/800px-Bertha_Petterssons_hus_01.jpg")!,
    type: .area,
    attributes: .area(.init(
        name: "Kvarngärdet",
        ratingFormatted: "4/5",
        averagePrice: 51300
    ))
)

let mockPropertyList = PropertyList(items: [mockPropertyItem, mockAreaItem])

let mockPropertyDetails = PropertyDetails(
    type: .highlightedProperty,
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg")!,
    description: "The living room can be furnished according to your own wishes and tastes, here the whole family can gather and enjoy each other's company. From the living room you reach the terrace overlooking the lush courtyard which is located in undisturbed and secluded location.",
    askingPrice: 2650000,
    daysSincePublishing: 1,
    livingArea: 120,
    numberOfRooms: 5,
    patio: .yes,
    streetAddress: "Mockvägen 1",
    area: "Heden",
    municipality: "Gällivare kommun"
)
