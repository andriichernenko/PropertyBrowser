//
//  PropertyList.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

struct PropertyList: Equatable, Hashable, Decodable {
    let items: [Item]
    
    struct Item: Equatable, Hashable, Decodable {
        let id: ID
        let imageURL: URL
        let type: PropertyType
        let attributes: Attributes

        init(id: ID, imageURL: URL, type: PropertyType, attributes: Attributes) {
            self.id = id
            self.imageURL = imageURL
            self.type = type
            self.attributes = attributes
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Item.CodingKeys.self)

            self.id = try container.decode(ID.self, forKey: .id)
            self.imageURL = try container.decode(URL.self, forKey: .imageURL)
            self.type = try container.decode(PropertyType.self, forKey: .type)
            
            switch self.type {
            case .area:
                self.attributes = .area(try AreaItemAttributes(from: decoder))
            
            case .property, .highlightedProperty:
                self.attributes = .property(try PropertyItemAttributes(from: decoder))
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case id, imageURL = "image", type
        }
        
        struct ID: RawRepresentable, Equatable, Hashable, Decodable {
            let rawValue: String
        }
        
        enum Attributes: Equatable, Hashable, Decodable {
            case area(AreaItemAttributes)
            case property(PropertyItemAttributes)
        }
    }
}

enum PropertyType: String, Equatable, Hashable, Decodable {
    case area = "Area", property = "Property", highlightedProperty = "HighlightedProperty"
}

struct AreaItemAttributes: Equatable, Hashable, Decodable  {
    let name: String
    let ratingFormatted: String
    let averagePrice: MonetaryAmount
    
    enum CodingKeys: String, CodingKey {
        case name = "area", ratingFormatted, averagePrice
    }
}

struct PropertyItemAttributes: Equatable, Hashable, Decodable  {
    let daysSincePublishing: Int

    let askingPrice: MonetaryAmount

    let livingArea: Int
    let numberOfRooms: Int
    let monthlyFee: MonetaryAmount?

    let streetAddress: String
    let area: String
    let municipality: String
    
    enum CodingKeys: String, CodingKey {
        case daysSincePublishing = "daysSincePublish",
             askingPrice,
             livingArea, numberOfRooms, monthlyFee,
             streetAddress, area, municipality
    }
}
