//
//  PropertyListViewerViewModelTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import XCTest

@testable import PropertyBrowser

final class PropertyListViewerViewModelTests: XCTestCase {

    func testViewModel_initialState() throws {
        let propertyList = mockPropertyList
        let viewModel = PropertyListViewer.ViewModel(propertyService: MockPropertyService(list: propertyList))
        
        XCTAssertNil(viewModel.selectedPropertyItem)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertTrue(propertyList.items.allSatisfy { !viewModel.isSelected($0) })
    }
    
    func testViewModel_whenItemTappedWhenListNotLoaded_isNotSelected() throws {
        let viewModel = PropertyListViewer.ViewModel(propertyService: MockPropertyService())
        
        viewModel.state = .idle
        viewModel.didTapListItem(mockPropertyItem)

        XCTAssertFalse(viewModel.isSelected(mockPropertyItem))
        
        viewModel.state = .loading
        viewModel.didTapListItem(mockPropertyItem)

        XCTAssertFalse(viewModel.isSelected(mockPropertyItem))
        
        viewModel.state = .failed(error: SomeError())
        viewModel.didTapListItem(mockPropertyItem)

        XCTAssertFalse(viewModel.isSelected(mockPropertyItem))
    }
    
    func testViewModel_whenItemIsTappedWhenListIsLoaded_canSelectFirstItem() throws {
        let viewModel = PropertyListViewer.ViewModel(propertyService: MockPropertyService())
        let items = [mockPropertyItem, mockAreaItem]
        
        viewModel.state = .succeeded(value: items.map { .init(item: $0) })
        
        viewModel.didTapListItem(items[1])
        XCTAssertFalse(viewModel.isSelected(items[1]))
        
        viewModel.didTapListItem(items[0])
        XCTAssertTrue(viewModel.isSelected(items[0]))
    }
    
    func testViewModel_whenViewAppears_startsLoading() throws {
        let items = [mockPropertyItem, mockAreaItem]
        let viewModel = PropertyListViewer.ViewModel(propertyService: MockPropertyService(list: .init(items: items)))
        
        XCTAssertEqual(viewModel.state, .idle)
        
        viewModel.viewDidAppear()
        XCTAssertEqual(viewModel.state, .loading)
        
        let loadingCompletion = expectation(description: "the list has finished loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.state, .succeeded(value: items.map { .init(item: $0) }))
            loadingCompletion.fulfill()
        }
        
        wait(for: [loadingCompletion], timeout: 1)
    }
}

final class PropertyListViewerItemFormattingTests: XCTestCase {
    
    func testFormatting_areaItem() throws {
        let item = PropertyListViewer.ItemModel(item: mockAreaItem)
        
        XCTAssertEqual(item.id, mockAreaItem.id.rawValue)
        XCTAssertEqual(item.imageURL, mockAreaItem.imageURL)
        
        guard case let .area(name, rating, averagePrice) = item.type else {
            XCTFail("Expected list item to be formatted as area, but it was not")
            return
        }
        
        XCTAssertEqual(name, "Kvarngärdet")
        XCTAssertEqual(rating, "4/5")
        XCTAssertEqual(averagePrice, "51 300 SEK")
    }
    
    func testFormatting_propertyItem() throws {
        let item = PropertyListViewer.ItemModel(item: mockPropertyItem)
        
        XCTAssertEqual(item.id, mockPropertyItem.id.rawValue)
        XCTAssertEqual(item.imageURL, mockPropertyItem.imageURL)
        
        guard case let .property(imageIsHighlighted, streetAddress, area, price, livingArea, roomCount) = item.type else {
            XCTFail("Expected list item to be formatted as property, but it was not")
            return
        }
        
        XCTAssertTrue(imageIsHighlighted)
        XCTAssertEqual(streetAddress, "Mockvägen 4")
        XCTAssertEqual(area, "Kvarngärdet, Uppsala kommun")
        XCTAssertEqual(price, "1 150 000 SEK")
        XCTAssertEqual(livingArea, "29 m²")
        XCTAssertEqual(roomCount, "1 rooms")
    }
}


private struct SomeError: Error {}
