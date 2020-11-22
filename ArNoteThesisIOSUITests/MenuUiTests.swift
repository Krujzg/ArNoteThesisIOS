import XCTest

class MenuUiTests: XCTestCase
{
    let app = XCUIApplication()
    let loginPredicate = NSPredicate(format: "exists == 1")
    
    var loginButton : XCUIElement? = nil
    var arViewResolveButton : XCUIElement? = nil
    var myNotesPageTitle : XCUIElement? = nil

    var arNoteTitle : XCUIElement? = nil
    var arNoteDesc : XCUIElement? = nil
    var arNoteButton : XCUIElement? = nil

    var myNotesTitle : XCUIElement? = nil
    var myNotesDesc : XCUIElement? = nil
    var myNotesButton : XCUIElement? = nil

    var logoutTitle : XCUIElement? = nil
    var logoutDesc : XCUIElement? = nil
    var logoutbutton : XCUIElement? = nil

    override func setUpWithError() throws {
 
        continueAfterFailure = false
        app.launch()
        loginButton = app.buttons["LoginButton"]
        
        arNoteTitle = app.staticTexts["arNoteTitle"]
        arNoteDesc = app.staticTexts["arNoteDesc"]
        arNoteButton = app.buttons["arNoteButton"]
        
        myNotesTitle = app.staticTexts["myNotesTitle"]
        myNotesDesc = app.staticTexts["myNotesDesc"]
        myNotesButton = app.buttons["myNoteButton"]
        
        logoutTitle = app.staticTexts["logoutTitle"]
        logoutDesc = app.staticTexts["logoutDesc"]
        logoutbutton = app.buttons["logoutButton"]
        
        myNotesPageTitle = app.navigationBars["MyNotes"].staticTexts["MyNotes"]
        arViewResolveButton = app.buttons["resolveButton"]
        
    }
    
    override func tearDownWithError() throws{}
    
    func StartWithLogin()
    {
        loginButton?.tap()
        expectation(for: loginPredicate, evaluatedWith: arNoteTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testIfArNoteButtonNavigatesToArView()
    {
        StartWithLogin()
        
        arNoteButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: arViewResolveButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testIfMyNotesButtonNavigatesToMyNotesView()
    {
        StartWithLogin()
        myNotesButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesPageTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testIfLogoutbuttonNavigatesToLoginView()
    {
        StartWithLogin()
        logoutbutton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: loginButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testIfArNoteButtonCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((arNoteButton?.exists) != nil))
        XCTAssert(((arNoteButton?.isEnabled) != nil))
    }
    
    func testIfArNoteTitleCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((arNoteTitle?.exists) != nil))
        XCTAssert(((arNoteTitle?.isEnabled) != nil))
    }
    
    func testIfArNoteDescCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((arNoteDesc?.exists) != nil))
        XCTAssert(((arNoteDesc?.isEnabled) != nil))
    }
    
    func testIfMyNotesButtonCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((myNotesButton?.exists) != nil))
        XCTAssert(((myNotesButton?.isEnabled) != nil))
    }
    
    func testIfMyNotesTitleCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((myNotesTitle?.exists) != nil))
        XCTAssert(((myNotesTitle?.isEnabled) != nil))
    }
    
    func testIfMyNotesDescCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((myNotesDesc?.exists) != nil))
        XCTAssert(((myNotesDesc?.isEnabled) != nil))
    }
    
    func testIfLogoutButtonCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((logoutbutton?.exists) != nil))
        XCTAssert(((logoutbutton?.isEnabled) != nil))
    }
    
    func testIfLogoutTitleCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((logoutTitle?.exists) != nil))
        XCTAssert(((logoutTitle?.isEnabled) != nil))
    }
    
    func testIfLogoutDescCanBeSeen()
    {
        StartWithLogin()
        XCTAssert(((logoutDesc?.exists) != nil))
        XCTAssert(((logoutDesc?.isEnabled) != nil))
    }
    
    func testIfArNoteContainerTextsIsCorrects()
    {
        StartWithLogin()
        XCTAssertEqual(arNoteTitle?.label, "AR Note")
        XCTAssertEqual(arNoteDesc?.label, "Place your Augmented Reality Note")
    }
    
    func testIfMyNotesContainerTextsIsCorrects()
    {
        StartWithLogin()
        XCTAssertEqual(myNotesTitle?.label, "My Notes")
        XCTAssertEqual(myNotesDesc?.label, "Check your notes")
    }
    
    func testIfLogoutContainerTextsIsCorrects()
    {
        StartWithLogin()
        XCTAssertEqual(logoutTitle?.label, "Log out")
        XCTAssertEqual(logoutDesc?.label, "Logout from the application")
    }
}
