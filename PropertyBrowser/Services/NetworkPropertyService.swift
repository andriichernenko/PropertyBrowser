//
//  NetworkPropertyService.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

final class NetworkPropertyService: PropertyService {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchPropertyList() async throws -> PropertyList {
        // TODO: Handle HTTP errors
        let (data, _) = try await session.data(from: .propertyList)
        let propertyList = try JSONDecoder().decode(PropertyList.self, from: data)
        
        return propertyList
    }
    
    func fetchDetails(for: PropertyList.Item) async throws -> PropertyDetails {
        // TODO: Handle HTTP errors
        let (data, _) = try await session.data(from: .propertyDetails)
        let propertyList = try JSONDecoder().decode(PropertyDetails.self, from: data)
        
        return propertyList
    }
}

private extension URL {
    
    static let propertyList = URL(string: "https://pastebin.com/raw/nH5NinBi")!
    
    static let propertyDetails = URL(string: "https://pastebin.com/raw/uj6vtukE")!
}
