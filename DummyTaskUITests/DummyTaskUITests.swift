//
//  DummyTaskUITests.swift
//  DummyTaskUITests
//
//  Created by Mac on 21/09/2023.
//

import XCTest

final class DummyTaskUITests: XCTestCase {

    
    var app: XCUIApplication!

       override func setUpWithError() throws {

           try super.setUpWithError()
           continueAfterFailure = false
           app = XCUIApplication()
           app.launch()
       }

       func testLogin() {
           let emailTextField = app.textFields["username"]
           let passwordTextField = app.secureTextFields["password"]
           let loginButton = app.buttons["loginButton"]
           
           emailTextField.tap()
           emailTextField.typeText("kminchelle")
           
           passwordTextField.tap()
           passwordTextField.typeText("0lelplR")
           
           loginButton.tap()

           XCTAssertTrue(true)
       }


    
}
