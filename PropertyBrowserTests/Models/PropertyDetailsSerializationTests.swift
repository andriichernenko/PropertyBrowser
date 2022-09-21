//
//  PropertyDetailsSerializationTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-20.
//

import XCTest

@testable import PropertyBrowser

final class PropertyDetailsSerializationTests: XCTestCase {
    
    func testDeserialization() throws {
        let deserializedPlot = try JSONDecoder().decode(PropertyDetails.self, from: propertyDetailsJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedPlot, referencePropertyDetails)
    }
}

private let referencePropertyDetails = PropertyDetails(
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

private let propertyDetailsJSON = """
{
    "type": "HighlightedProperty",
    "id": "1234567890",
    "askingPrice": 2650000,
    "municipality": "Gällivare kommun",
    "area": "Heden",
    "daysSincePublish": 1,
    "livingArea": 120,
    "numberOfRooms": 5,
    "streetAddress": "Mockvägen 1",
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg",
    "description": "The living room can be furnished according to your own wishes and tastes, here the whole family can gather and enjoy each other's company. From the living room you reach the terrace overlooking the lush courtyard which is located in undisturbed and secluded location.",
    "patio": "Yes"
}
"""
