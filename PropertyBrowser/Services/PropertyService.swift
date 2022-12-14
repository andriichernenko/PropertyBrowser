//
//  PropertyService.swift
//  PropertyBrowser
//
//  Created by Andrii Chernenko on 2022-09-19.
//

import Foundation

protocol PropertyService {
    
    func fetchPropertyList() async throws -> PropertyList
    
    func fetchDetails(for: PropertyList.Item) async throws -> PropertyDetails
}
