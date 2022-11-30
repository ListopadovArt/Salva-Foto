//
//  EditProfileViewControllerTests.swift
//  SalvaFotoUnitTests
//
//  Created by Artem Listopadov on 30.10.22.
//

import Foundation
import XCTest

@testable import SalvaFoto

class EditProfileViewControllerTests: XCTestCase {
    var vc: EditProfileViewController!
    
    override func setUp() {
        super.setUp()
        vc = EditProfileViewController()
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
        XCTAssertEqual("Profile", model[0].header)
        XCTAssertEqual(4, model[0].placeholder?.count)
        XCTAssertEqual("First name", model[0].placeholder?[0])
        XCTAssertEqual("Last name", model[0].placeholder?[1])
        XCTAssertEqual("Username", model[0].placeholder?[2])
        XCTAssertEqual("Email", model[0].placeholder?[3])
        XCTAssertEqual(4, model[0].tags?.count)
        XCTAssertEqual("Location", model[1].header)
        XCTAssertEqual(1, model[1].placeholder?.count)
        XCTAssertEqual(1, model[1].tags?.count)
        XCTAssertEqual("City", model[1].placeholder?[0])
    }
}
