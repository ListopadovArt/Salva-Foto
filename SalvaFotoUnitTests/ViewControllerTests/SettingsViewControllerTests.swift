//
//  SettingsViewControllerTests.swift
//  SalvaFotoUnitTests
//
//  Created by Artem Listopadov on 30.10.22.
//

import Foundation
import XCTest

@testable import SalvaFoto

class SettingsViewControllerTests: XCTestCase {
    var vc: SettingsViewController!
    
    override func setUp() {
        super.setUp()
        vc = SettingsViewController()
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(for: .serverError)
        XCTAssertEqual("Server Error", titleAndMessage.0)
        XCTAssertEqual("We could not process your request. Please try again.", titleAndMessage.1)
    }
    
    func testTitleAndMessageForDecodingError() throws {
        let titleAndMessage = vc.titleAndMessageForTesting(for: .decodingError)
        XCTAssertEqual("Network Error", titleAndMessage.0)
        XCTAssertEqual("Ensure you are connected to the internet. Please try again.", titleAndMessage.1)
    }
    
    func testTableModel() throws {
        let model = vc.tableModelForTesting()
        XCTAssertEqual("Support", model[0].header)
        XCTAssertEqual(1, model[0].tags?.count)
        XCTAssertEqual("Account", model[1].header)
        XCTAssertEqual(1, model[1].tags?.count)
        XCTAssertEqual("Other", model[2].header)
        XCTAssertEqual(3, model[2].tags?.count)
    }
}
