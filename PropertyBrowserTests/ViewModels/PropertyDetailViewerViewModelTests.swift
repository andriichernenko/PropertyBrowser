//
//  PropertyDetailViewerViewModelTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import XCTest

@testable import PropertyBrowser

final class PropertyDetailViewerViewModelTests: XCTestCase {

    func testViewModel_initialState() throws {
        let viewModel = PropertyDetailViewer.ViewModel(
            item: mockPropertyItem,
            propertyService: MockPropertyService(details: mockPropertyDetails)
        )
        
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testViewModel_whenViewAppears_startsLoading() throws {
        let viewModel = PropertyDetailViewer.ViewModel(
            item: mockPropertyItem,
            propertyService: MockPropertyService(details: mockPropertyDetails)
        )
        
        XCTAssertEqual(viewModel.state, .idle)
        
        viewModel.viewDidAppear()
        XCTAssertEqual(viewModel.state, .loading)
        
        let loadingCompletion = expectation(description: "content has finished loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.state, .succeeded(value: .init(propertyDetails: mockPropertyDetails)))
            loadingCompletion.fulfill()
        }
        
        wait(for: [loadingCompletion], timeout: 1)
    }
}

final class PropertyDetailViewerFormattingTests: XCTestCase {
    
    func testFormatting() throws {
        let formattedDetails = FormattedPropertyDetails(propertyDetails: mockPropertyDetails)
        
        XCTAssertTrue(formattedDetails.imageIsHighlighted)
        XCTAssertEqual(formattedDetails.streetAddress, "Mockvägen 1")
        XCTAssertEqual(formattedDetails.areaInfo, "Heden, Gällivare kommun")
        XCTAssertEqual(formattedDetails.askingPrice, "2 650 000 SEK")
        XCTAssertEqual(formattedDetails.description, mockPropertyDetails.description)
        XCTAssertEqual(formattedDetails.livingArea, "120 m²")
        XCTAssertEqual(formattedDetails.roomCount, "5")
        XCTAssertEqual(formattedDetails.patio, "Yes")
        XCTAssertEqual(formattedDetails.daysSincePublishing, "1")
    }
}
