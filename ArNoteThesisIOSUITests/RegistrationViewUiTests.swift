import XCTest

class RegistrationViewUiTests: XCTestCase {

    let app = XCUIApplication()
    var emailTextField : XCUIElement? = nil
    var passwordTextField : XCUIElement? = nil
    var passwordTextFieldAgain : XCUIElement? = nil
    var returnButton : XCUIElement? = nil
    var pasteMenuItem : XCUIElement? = nil
    var registerButton : XCUIElement? = nil
    var GoToRegisterPageLoginButton : XCUIElement? = nil
    var registrationViewBackground :XCUIElement? = nil
    var loginViewBackGround :XCUIElement? = nil
    
    override func setUpWithError() throws
    {
        continueAfterFailure = false
        app.launch()
        emailTextField = app.textFields["EmailTextFieldRegistera"]
        passwordTextField = app.textFields["PasswordTextFieldRegister"]
        passwordTextFieldAgain = app.textFields["PasswordTextFieldRegister"]
        returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        pasteMenuItem = app.menuItems["Paste"]
        registerButton = app.buttons["Register"]
        GoToRegisterPageLoginButton = app.buttons["GoToRegistration"]
        registrationViewBackground = app.otherElements["RegistrationViewBackGround"]
        loginViewBackGround = app.otherElements["loginViewBackGround"]
    }
    
    func testInvalidValidRegistration()
    {
        GoToRegisterPageLoginButton?.tap()
        let predicate = NSPredicate(format: "exists == 0")
        expectation(for: predicate, evaluatedWith: loginViewBackGround, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testInvalidValidRegistrationWithNoInputs()
    {
        GoToRegisterPageLoginButton?.tap()
        registerButton?.tap()
        let predicate = NSPredicate(format: "exists == 0")
        expectation(for: predicate, evaluatedWith: loginViewBackGround, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testIfRegistrationButtonCanNavigatoToRegistrationView()
    {
        GoToRegisterPageLoginButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: registrationViewBackground, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testIfEmailTextFieldCanBeSeenOnLoginPage()
    {
        XCTAssert(emailTextField!.exists)
        XCTAssert(emailTextField!.isEnabled)
    }
    
    func testIfPasswordTextFieldCanBeSeenOnLoginPage()
    {
        XCTAssert(passwordTextField!.exists)
        XCTAssert(passwordTextField!.isEnabled)
    }
    
    func testIfGoToRegisterButtonCanBeSeenOnLoginPage()
    {
        XCTAssert(GoToRegisterPageLoginButton!.exists)
        XCTAssert(GoToRegisterPageLoginButton!.isEnabled)
    }
}
