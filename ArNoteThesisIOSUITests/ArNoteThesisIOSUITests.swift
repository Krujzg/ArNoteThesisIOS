import XCTest

class LoginSceneUiTests: XCTestCase
{
    let app = XCUIApplication()
    var loginPageLogo : XCUIElement? = nil
    var emailTextField : XCUIElement? = nil
    var passwordTextField : XCUIElement? = nil
    var returnButton : XCUIElement? = nil
    var pasteMenuItem : XCUIElement? = nil
    var loginButton : XCUIElement? = nil
    var LoginPageTitle : XCUIElement? = nil
    var GoToRegisterPageLoginButton : XCUIElement? = nil
    var menuBackground: XCUIElement? = nil
    var LoginPageEmailTitle: XCUIElement? = nil
    var LoginPagePasswordTitle :XCUIElement? = nil
    var registrationViewBackground :XCUIElement? = nil
    var loginViewBackGround :XCUIElement? = nil
    
    override func setUpWithError() throws
    {
        continueAfterFailure = false
        //app.launchArguments.append("UITEST")
        app.launch()
        loginPageLogo = app.images["arnote_menu"]
        emailTextField = app.textFields["EmailTextFieldLogin"]
        
        passwordTextField = app.secureTextFields["PasswordTextField"]
        returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        pasteMenuItem = app.menuItems["Paste"]
        loginButton = app.buttons["Login"]
        LoginPageTitle = app.navigationBars["Login"].staticTexts["Login"]
        GoToRegisterPageLoginButton = app.buttons["GoToRegistration"]
        menuBackground = app.otherElements["menubackground"]
        LoginPageEmailTitle = app.staticTexts["Email"]
        LoginPagePasswordTitle = app.staticTexts["Password"]
        registrationViewBackground = app.otherElements["RegistrationViewBackGround"]
        loginViewBackGround = app.otherElements["loginViewBackGround"]
    }
    
    func testValidLogin()
    {
        let validEmail = "uiteszt@gmail.com"
        let validPassword = "uiteszt123"
                                                                                
        emailTextField?.tap()
        emailTextField?.clearAndEnterText(text: validEmail)
        returnButton?.tap()
                                
        UIPasteboard.general.string = validPassword
        
        passwordTextField?.tap()
        passwordTextField?.doubleTap()
        pasteMenuItem?.tap()
        
        loginButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: menuBackground, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testInvalidValidLogin()
    {
        let invalidEmail = "invalidemail"
        let invalidPassword = "invalidpassword"
        
        emailTextField?.tap()
        emailTextField?.clearAndEnterText(text: invalidEmail)
        returnButton?.tap()
        
        UIPasteboard.general.string = invalidPassword
        
        passwordTextField?.tap()
        passwordTextField?.doubleTap()
        pasteMenuItem?.tap()
        
        loginButton?.tap()
        let predicate = NSPredicate(format: "exists == 0")
        expectation(for: predicate, evaluatedWith: menuBackground, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testIfRegistrationButtonCanNavigatoToRegistrationView()
    {
        GoToRegisterPageLoginButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: registrationViewBackground, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testIfTitleCanBeSeenOnLoginPage()
    {
        XCTAssert(((LoginPageTitle?.exists) != nil))
        XCTAssert(((LoginPageTitle?.isEnabled) != nil))
    }
    
    func testIfLogoCanBeSeenOnLoginPage()
    {
        XCTAssert(((loginPageLogo?.exists) != nil))
        XCTAssert(((loginPageLogo?.isEnabled) != nil))
    }
    
    func testIfEmailTitleCanBeSeenOnLoginPage()
    {
        XCTAssert(LoginPageEmailTitle!.exists)
        XCTAssert(LoginPageEmailTitle!.isEnabled)
    }
    
    func testIfPasswordTitleCanBeSeenOnLoginPage()
    {
        XCTAssert(LoginPagePasswordTitle!.exists)
        XCTAssert(LoginPagePasswordTitle!.isEnabled)
    }
    
    func testIfEmailTextFieldCanBeSeenOnLoginPage()
    {
        XCTAssert(((emailTextField?.exists) != nil))
    }
    
    func testIfPasswordTextFieldCanBeSeenOnLoginPage()
    {
        XCTAssert(passwordTextField!.exists)
        XCTAssert(passwordTextField!.isEnabled)
    }
    
    func testIfLoginButtonCanBeSeenOnLoginPage()
    {
        XCTAssert(loginButton!.exists)
        XCTAssert(loginButton!.isEnabled)
    }
    
    func testIfGoToRegisterButtonCanBeSeenOnLoginPage()
    {
        XCTAssert(GoToRegisterPageLoginButton!.exists)
        XCTAssert(GoToRegisterPageLoginButton!.isEnabled)
    }
}

extension XCUIElement{
    func clearAndEnterText(text : String)
    {
        guard let stringValue = self.value as? String  else
        {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
