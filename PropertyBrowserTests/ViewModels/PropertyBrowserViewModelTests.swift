//
//  PropertyBrowserViewModelTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import XCTest

@testable import PropertyBrowser

final class PropertyBrowserViewModelTests: XCTestCase {

    func testViewModel_initialState() throws {
        let viewModel = PropertyBrowser.ViewModel()
        
        XCTAssertNil(viewModel.selectedPropertyItem.value)
        XCTAssertFalse(viewModel.hasSelection)
    }
    
    func testViewModel_whenItemSelected() throws {
        let viewModel = PropertyBrowser.ViewModel()
        viewModel.selectedPropertyItem.value = mockPropertyItem
        
        XCTAssertTrue(viewModel.hasSelection)
    }
    
    func testViewModel_whenItemDeselected() throws {
        let viewModel = PropertyBrowser.ViewModel()
        viewModel.selectedPropertyItem.value = mockPropertyItem
        viewModel.selectedPropertyItem.value = nil
        
        XCTAssertFalse(viewModel.hasSelection)
    }
}
