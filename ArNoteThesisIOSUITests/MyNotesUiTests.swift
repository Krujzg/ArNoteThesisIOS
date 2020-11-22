import XCTest

class MyNotesUiTests: XCTestCase {

    let app = XCUIApplication()
    var loginButton : XCUIElement? = nil
    var myNotesButton : XCUIElement? = nil
    var myNotesTable : XCUIElementQuery? = nil
    var myNotesTableCellQuery : XCUIElementQuery? = nil
    
    var myNotesShortCodeTitle : XCUIElement? = nil
    var myNotesTypeTitle : XCUIElement? = nil
    var myNotesDateTitle : XCUIElement? = nil
    var myNotesTextTitle : XCUIElement? = nil
    
    var myNotesShortCodeText : XCUIElement? = nil
    var myNotesTypeText : XCUIElement? = nil
    var myNotesDateText : XCUIElement? = nil
    var myNotesTextText : XCUIElement? = nil
    
    var myNotesPageTitle : XCUIElement? = nil
    
    var cellCount : Int = 0

    override func setUpWithError() throws {
 
        continueAfterFailure = false
        app.launch()
        loginButton = app.buttons["LoginButton"]
        myNotesButton = app.buttons["myNoteButton"]
        myNotesPageTitle = app.navigationBars["MyNotes"].staticTexts["MyNotes"]
        
        myNotesShortCodeTitle = app.tables.cells.element(boundBy: 0).staticTexts["ShortcodeTitle"]
        myNotesTypeTitle = app.tables.cells.element(boundBy: 0).staticTexts["TypeTitle"]
        myNotesDateTitle = app.tables.cells.element(boundBy: 0).staticTexts["DateTitle"]
        myNotesTextTitle = app.tables.cells.element(boundBy: 0).staticTexts["TextTitle"]
        
        myNotesShortCodeText = app.tables.cells.element(boundBy: 0).staticTexts["shortcodeText"]
        myNotesTypeText = app.tables.cells.element(boundBy: 0).staticTexts["typetext"]
        myNotesDateText = app.tables.cells.element(boundBy: 0).staticTexts["datetext"]
        myNotesTextText = app.tables.cells.element(boundBy: 0).staticTexts["texttext"]
        
        
    }
    override func tearDownWithError() throws{}

    func StartNavigatonToMyNotes()
    {
        loginButton?.tap()
        let loginPredicate = NSPredicate(format: "exists == 1")
        expectation(for: loginPredicate, evaluatedWith: myNotesButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        myNotesButton?.tap()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesPageTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testIfCellCountIsGreaterThanZero()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTypeTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        cellCount = app.tables.cells.count
        XCTAssertGreaterThan(cellCount, 0)
    }
    
    func testIfTypeTitleCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTypeTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesTypeTitle!.exists)
        XCTAssert(myNotesTypeTitle!.isEnabled)
    }
    
    func testIfTypeTitleIsType()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTextTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(myNotesTypeTitle?.label, "Type:")
    }
    
    func testIfShortCodeTitleCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesShortCodeTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesShortCodeTitle!.exists)
        XCTAssert(myNotesShortCodeTitle!.isEnabled)
    }
    
    func testIfShortCodeTitleIsShortCode()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesShortCodeTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(myNotesShortCodeTitle?.label, "Shortcode:")
    }
    
    func testIfDateTitlecanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesDateTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesDateTitle!.exists)
        XCTAssert(myNotesDateTitle!.isEnabled)
    }
    
    func testIfDateTitleIsDate()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesDateTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(myNotesDateTitle?.label, "Date:")
    }
    
    func testIfTextTitleCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTextTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesTextTitle!.exists)
        XCTAssert(myNotesTextTitle!.isEnabled)
    }
    
    func testIfTextTitleIsText()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTextTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(myNotesTextTitle?.label, "Text:")
    }
    
    func testIfShortCodeTextCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesShortCodeText, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesShortCodeText!.exists)
        XCTAssert(myNotesShortCodeText!.isEnabled)
    }
    
    func testIfTypeTextCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTextTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesTypeText!.exists)
        XCTAssert(myNotesTypeText!.isEnabled)
    }
    
    func testifDateTextCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTextTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesDateText!.exists)
        XCTAssert(myNotesDateText!.isEnabled)
    }
    
    func testIfTextTextCanBeSeen()
    {
        StartNavigatonToMyNotes()
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: myNotesTextTitle, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(myNotesTextText!.exists)
        XCTAssert(myNotesTextText!.isEnabled)
    }
}
