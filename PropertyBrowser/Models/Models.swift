//
//  Models.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

struct PropertyList: Equatable, Hashable, Decodable {
    let items: [Property]
}

struct Property: Equatable, Hashable, Decodable {
    let id: ID
    let imageURL: URL
    let kind: Kind

    init(id: Property.ID, imageURL: URL, kind: Property.Kind) {
        self.id = id
        self.imageURL = imageURL
        self.kind = kind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Property.CodingKeys.self)

        self.id = try container.decode(ID.self, forKey: .id)
        self.imageURL = try container.decode(URL.self, forKey: .imageURL)
        
        let propertyKind = try container.decode(String.self, forKey: .kind)
        
        switch propertyKind {
        case "Area":
            let details = try PlotDetails(from: decoder)
            self.kind = .plot(details)
        
        case "Property":
            let details = try PropertyDetails(from: decoder)
            self.kind = .property(details)
        
        case "HighlightedProperty":
            let details = try PropertyDetails(from: decoder)
            self.kind = .highlightedProperty(details)
        
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: decoder.codingPath + [CodingKeys.kind],
                debugDescription: "\(propertyKind) is not a valid property type"
            ))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, imageURL = "image", kind = "type"
    }
    
    struct ID: RawRepresentable, Equatable, Hashable, Decodable {
        let rawValue: String
    }

    enum Kind: Equatable, Hashable, Decodable {
        case plot(PlotDetails)
        case property(PropertyDetails)
        case highlightedProperty(PropertyDetails)
    }
}

struct PropertyDetails: Equatable, Hashable, Decodable {
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

struct PlotDetails: Equatable, Hashable, Decodable {
    let area: String
    let ratingFormatted: String
    let averagePrice: MonetaryAmount
}

typealias MonetaryAmount = Decimal
