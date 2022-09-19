//
//  PropertyDetails.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

struct PropertyDetails: Equatable, Hashable, Decodable {
    let type: PropertyType
    let imageURL: URL
    let description: String
    
    let askingPrice: MonetaryAmount
    let daysSincePublishing: Int
    
    let livingArea: Int
    let numberOfRooms: Int
    var patio: Patio
    
    let streetAddress: String
    let area: String
    let municipality: String
    
    enum CodingKeys: String, CodingKey {
        case type,
             imageURL = "image", description,
             askingPrice, daysSincePublishing = "daysSincePublish",
             livingArea, numberOfRooms, patio,
             streetAddress, area, municipality
    }
    
    struct Patio: RawRepresentable, Equatable, Hashable, Decodable {
        static let yes = Patio(rawValue: "Yes")
        
        var rawValue: String
    }
}
