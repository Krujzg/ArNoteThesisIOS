//
//  ArNoteThesisIOSUITests.swift
//  ArNoteThesisIOSUITests
//
//  Created by Gergo on 2020. 10. 11..
//

import XCTest

class ArNoteThesisIOSUITests: XCTestCase {

    override func setUpWithError() throws {
 
        continueAfterFailure = false
        XCUIApplication().launch()

    }

    override func tearDownWithError() throws
    {
        
    }
    
    func testValidLogin()
    {
        let validEmail = "teszt@gmail.cím"
        let validPassword = "teszt123"
        let app = XCUIApplication()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1)
        
        let emailTextField = element.children(matching: .textField).element
        let passwordTextField = element.children(matching: .secureTextField).element
    
        emailTextField.tap()
        emailTextField.clearAndEnterText(text: validEmail)
        
        passwordTextField.tap()
        passwordTextField.clearAndEnterText(text: validPassword)
        
        app.buttons["Login"].tap()
        
    }
}

extension XCUIElement{
    func clearAndEnterText(text : String)
    {
        guard let stringValue = self.value as? String  else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
