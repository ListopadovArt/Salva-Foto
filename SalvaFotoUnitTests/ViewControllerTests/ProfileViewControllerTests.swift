//
//  ProfileViewControllerTests.swift
//  SalvaFotoUnitTests
//
//  Created by Artem Listopadov on 30.10.22.
//

import Foundation
import XCTest

@testable import SalvaFoto

class ProfileViewControllerTests: XCTestCase {
    var vc: ProfileViewController!
    
    override func setUp() {
        super.setUp()
        vc = ProfileViewController()
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
}
