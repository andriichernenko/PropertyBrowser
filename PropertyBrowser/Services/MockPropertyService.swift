//
//  MockPropertyService.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

class MockPropertyService: PropertyService {
    private let list: PropertyList
    
    init(list: PropertyList = .init(items: [mockProperty])) {
        self.list = list
    }
    
    func fetchPropertyList() async throws -> PropertyList {
        return list
    }
    
    func fetchDetails(by id: Property.ID) async throws -> Property {
        return list.items
            .first(where: { $0.id == id })!
    }
}

let mockProperty = Property(
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
