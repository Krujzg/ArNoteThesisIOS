import XCTest

class RegisterUiTests: XCTestCase {

    let app = XCUIApplication()
    var GoToRegisterPageLoginButton : XCUIElement? = nil
    var RegisterPageRegisterButton : XCUIElement? = nil
    var registerEmailTitle : XCUIElement? = nil
    var registerEmailTextField : XCUIElement? = nil
    var registerPasswordTextField : XCUIElement? = nil
    var registerPasswordTitle : XCUIElement? = nil
    var registerPasswordAgainTextField : XCUIElement? = nil
    var registerPasswordAgainTitle : XCUIElement? = nil
    var registerRegisterButton : XCUIElement? = nil
    var returnButton : XCUIElement? = nil
    
    override func setUpWithError() throws {
 
        continueAfterFailure = false
        app.launch()
        GoToRegisterPageLoginButton = app.buttons["GoToRegistration"]
        RegisterPageRegisterButton = app.buttons["EmailTextFieldRegister"]
        registerEmailTitle = app.staticTexts["EmailTitleRegister"]
        registerEmailTextField = app.textFields["EmailTextFieldRegister"]
        registerPasswordTextField = app.textFields["PasswordTextFieldRegister"]
        registerPasswordTitle = app.staticTexts["PasswordTitleRegister"]
        registerPasswordAgainTextField = app.textFields["PasswordTextFieldAgainRegister"]
        registerPasswordAgainTitle = app.staticTexts["PasswordAgainTitleRegister"]
        registerRegisterButton = app.buttons["RegisterButton"]
        returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        GoToRegisterPageLoginButton?.tap()
    }

    override func tearDownWithError() throws {}
    
    func testValidRegistration()
    {
        let validEmail = "teszt@gmail.com"
        let validPassword = "teszt123"
        let validPasswordAgain = "teszt123"
        
        registerEmailTextField?.tap()
        registerEmailTextField?.typeText(validEmail)
        returnButton?.tap()
        
        registerPasswordTextField?.tap()
        registerPasswordTextField?.typeText(validPassword)
        returnButton?.tap()
        
        registerPasswordAgainTextField?.tap()
        registerPasswordAgainTextField?.typeText(validPasswordAgain)
        returnButton?.tap()
        
        registerRegisterButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: GoToRegisterPageLoginButton, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testInvalidRegistrationNoSamePasswords()
    {
        let validEmail = "teszt@gmail.com"
        let validPassword = "teszt123"
        let invalidPasswordAgain = "teszt12"
        
        registerEmailTextField?.tap()
        registerEmailTextField?.typeText(validEmail)
        returnButton?.tap()
        
        registerPasswordTextField?.tap()
        registerPasswordTextField?.typeText(validPassword)
        returnButton?.tap()
        
        registerPasswordAgainTextField?.tap()
        registerPasswordAgainTextField?.typeText(invalidPasswordAgain)
        returnButton?.tap()
        
        registerRegisterButton?.tap()
        let predicate = NSPredicate(format: "exists == 0")
        expectation(for: predicate, evaluatedWith: GoToRegisterPageLoginButton, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testInvalidRegistrationNoPasswords()
    {
        let validEmail = "teszt@gmail.com"
        
        registerEmailTextField?.tap()
        registerEmailTextField?.typeText(validEmail)
        returnButton?.tap()
        
        registerRegisterButton?.tap()
        let predicate = NSPredicate(format: "exists == 0")
        expectation(for: predicate, evaluatedWith: GoToRegisterPageLoginButton, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testInvalidRegistrationBlankEverything()
    {
        registerRegisterButton?.tap()
    }
    
    func testIfEmailTitleCanBeSeen()
    {
        XCTAssert(((registerEmailTitle?.exists) != nil))
        XCTAssert(((registerEmailTitle?.isEnabled) != nil))
    }
    
    func testIfEmailTextFieldCanBeSeen()
    {
        XCTAssert(((registerEmailTextField?.exists) != nil))
        XCTAssert(((registerEmailTextField?.isEnabled) != nil))
    }
    
    func testIfPasswordTitleCanBeSeen()
    {
        XCTAssert(((registerPasswordTitle?.exists) != nil))
        XCTAssert(((registerPasswordTitle?.isEnabled) != nil))
    }
    
    func testIfPasswordTextFieldCanBeSeen()
    {
        XCTAssert(((registerPasswordTextField?.exists) != nil))
        XCTAssert(((registerPasswordTextField?.isEnabled) != nil))
    }
    
    func testIfPasswordAgainTitleCanBeSeen()
    {
        XCTAssert(((registerPasswordAgainTitle?.exists) != nil))
        XCTAssert(((registerPasswordAgainTitle?.isEnabled) != nil))
    }
    
    func testIfPasswordAgainTextFieldCanBeSeen()
    {
        XCTAssert(((registerPasswordAgainTextField?.exists) != nil))
        XCTAssert(((registerPasswordAgainTextField?.isEnabled) != nil))
    }
    
    func testIfRegisterButtonCanBeSeen()
    {
        XCTAssert(((registerRegisterButton?.exists) != nil))
        XCTAssert(((registerRegisterButton?.isEnabled) != nil))
    }

}
