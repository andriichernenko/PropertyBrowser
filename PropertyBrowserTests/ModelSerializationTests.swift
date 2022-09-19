//
//  ModelSerializationTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import XCTest

@testable import PropertyBrowser

final class ModelSerializationTests: XCTestCase {

    func testDeserialization_plot() throws {
        let deserializedPlot = try JSONDecoder().decode(Property.self, from: plotJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedPlot, referencePlot)
    }
    
    func testDeserialization_property() throws {
        let deserializedProperty = try JSONDecoder().decode(Property.self, from: propertyJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedProperty, referenceProperty)
    }
    
    func testDeserialization_highlightedProperty() throws {
        let deserializedProperty = try JSONDecoder().decode(Property.self, from: highlightedPropertyJSON.data(using: .utf8)!)
        XCTAssertEqual(deserializedProperty, referenceHighlightedProperty)
    }
    
    func testDeserialization_withInvalidPropertyKind_fails() throws {
        XCTAssertThrowsError(
            try JSONDecoder().decode(Property.self, from: propertyWithInvalidKindJSON.data(using: .utf8)!)
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

private let referencePlot = Property(
    id: .init(rawValue: "1234567892"),
    imageURL: .init(string: "https://i.imgur.com/v6GDnCG.png")!,
    kind: .plot(.init(
        area: "Stockholm",
        ratingFormatted: "4.5/5",
        averagePrice: 50100
    ))
)

private let plotJSON = """
{
    "type": "Area",
    "id": "1234567892",
    "area": "Stockholm",
    "ratingFormatted": "4.5/5",
    "averagePrice": 50100,
    "image": "https://i.imgur.com/v6GDnCG.png"
}
"""

private let referenceProperty = Property(
    id: .init(rawValue: "1234567893"),
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Bertha_Petterssons_hus_01.jpg/800px-Bertha_Petterssons_hus_01.jpg")!,
    kind: .property(.init(
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

private let referenceHighlightedProperty = Property(
    id: .init(rawValue: "1234567890"),
    imageURL: .init(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg")!,
    kind: .highlightedProperty(.init(
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

private let propertyWithInvalidKindJSON = """
{
    "type": "A random property type",
    "id": "1234567890",
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hus_i_svarttorp.jpg/800px-Hus_i_svarttorp.jpg"
}
"""

private let referencePropertyList = PropertyList(items: [referencePlot, referenceProperty, referenceHighlightedProperty])

private let propertyListJSON = """
{
    "items": [
        \(plotJSON),
        \(propertyJSON),
        \(highlightedPropertyJSON)
    ]
}
"""

private let propertyListWithInvalidItemsJSON = """
{
    "items": [
        \(plotJSON),
        \(propertyJSON),
        \(highlightedPropertyJSON),
        \(propertyWithInvalidKindJSON)
    ]
}
"""
