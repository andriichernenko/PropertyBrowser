//
//  MonetaryAmountFormattingTests.swift
//  PropertyBrowserTests
//
//  Created by Andrii Chernenko on 2022-09-21.
//

import XCTest

@testable import PropertyBrowser

final class MonetaryAmountFormattingTests: XCTestCase {

    func testFormatting() throws {
        XCTAssertEqual(MonetaryAmount(0).formatted, "0 SEK")
        XCTAssertEqual(MonetaryAmount(20.5).formatted, "20 SEK")
        XCTAssertEqual(MonetaryAmount(2000).formatted, "2 000 SEK")
        XCTAssertEqual(MonetaryAmount(2_650_000).formatted, "2 650 000 SEK")
        XCTAssertEqual(MonetaryAmount(-20).formatted, "-20 SEK")
    }
}
