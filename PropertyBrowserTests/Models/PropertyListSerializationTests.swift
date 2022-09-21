//
//  PropertyListSerializationTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import XCTest

@testable import PropertyBrowser

final class PropertyListSerializationTests: XCTestCase {

    func testDeserialization_area() throws {
        let deserializedPlot = try JSONDecoder().decode(PropertyList.Item.self, from: areaJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedPlot, referenceArea)
    }
    
    func testDeserialization_property() throws {
        let deserializedProperty = try JSONDecoder().decode(PropertyList.Item.self, from: propertyJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedProperty, referenceProperty)
    }
    
    func testDeserialization_highlightedProperty() throws {
        let deserializedProperty = try JSONDecoder().decode(PropertyList.Item.self, from: highlightedPropertyJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedProperty, referenceHighlightedProperty)
    }
    
    func testDeserialization_withInvalidPropertyType_fails() throws {
        XCTAssertThrowsError(
            try JSONDecoder().decode(PropertyList.Item.self, from: propertyWithInvalidTypeJSON.data(using: .utf8)!)
        )
    }
    
    func testDeserialization_propertyList() throws {
        let deserializedPropertyList = try JSONDecoder().decode(PropertyList.self, from: propertyListJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedPropertyList, referencePropertyList)
    }
    
    func testDeserialization_propertyListWithInvalidItems_fails() throws {
        XCTAssertThrowsError(
            try JSONDecoder().decode(PropertyList.self, from: propertyListWithInvalidItemsJSON.data(using: .utf8)!)
        )
    }
}

private let referenceArea = PropertyList.Item(
    id: .init(rawValue: "1234567892"),
    imageURL: .init(string: "https://i.imgur.com/v6GDnCG.png")!,
    type: .area,
    attributes: .area(.init(
        name: "Stockholm",
        ratingFormatted: "4.5/5",
        averagePrice: 50100
    ))
)

private let areaJSON = """
{
    "type": "Area",
    "id": "1234567892",
    "area": "Stockholm",
    "ratingFormatted": "4.5/5",
    "averagePrice": 50100,
    "image": "https://i.imgur.com/v6GDnCG.png"
}
"""

private let referenceProperty = PropertyList.Item(
    id: .init(rawValue: "1234567893"),
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Bertha_Petterssons_hus_01.jpg/800px-Bertha_Petterssons_hus_01.jpg")!,
    type: .property,
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

private let propertyJSON = """
{
    "type": "Property",
    "id": "1234567893",
    "askingPrice": 1150000,
    "monthlyFee": 2298,
    "municipality": "Uppsala kommun",
    "area": "Kvarngärdet",
    "daysSincePublish": 12,
    "livingArea": 29,
    "numberOfRooms": 1,
    "streetAddress": "Mockvägen 4",
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Bertha_Petterssons_hus_01.jpg/800px-Bertha_Petterssons_hus_01.jpg"
}
"""

private let referenceHighlightedProperty = PropertyList.Item(
    id: .init(rawValue: "1234567890"),
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg")!,
    type: .highlightedProperty,
    attributes: .property(.init(
        daysSincePublishing: 1,
        askingPrice: 2650000,
        livingArea: 120,
        numberOfRooms: 5,
        monthlyFee: nil,
        streetAddress: "Mockvägen 1",
        area: "Heden",
        municipality: "Gällivare kommun"
    ))
)

private let highlightedPropertyJSON = """
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
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg"
}
"""

private let propertyWithInvalidTypeJSON = """
{
    "type": "A random property type",
    "id": "1234567890",
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg"
}
"""

private let referencePropertyList = PropertyList(items: [referenceArea, referenceProperty, referenceHighlightedProperty])

private let propertyListJSON = """
{
    "items": [
        \(areaJSON),
        \(propertyJSON),
        \(highlightedPropertyJSON)
    ]
}
"""

private let propertyListWithInvalidItemsJSON = """
{
    "items": [
        \(areaJSON),
        \(propertyJSON),
        \(highlightedPropertyJSON),
        \(propertyWithInvalidTypeJSON)
    ]
}
"""
