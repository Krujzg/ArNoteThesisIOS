import XCTest

class ArSceneViewUiTests: XCTestCase {

    let app = XCUIApplication()
    var loginButton : XCUIElement? = nil
    var menuArNoteButton : XCUIElement? = nil
    var arActionsTitle : XCUIElement? = nil
    var resolveCodeTitle : XCUIElement? = nil
    var arNoteTypeTitle : XCUIElement? = nil
    var arnoteTextTitle : XCUIElement? = nil
    var arNoteTextTextField : XCUIElement? = nil
    var resolveCodeTextField : XCUIElement? = nil
    var typePickerView : XCUIElement? = nil
    var normalpickerWheel :  XCUIElement? = nil
    var urgentpickerWheel :  XCUIElement? = nil
    var warningpickerWheel :  XCUIElement? = nil
    var filterButton : XCUIElement? = nil
    var cancelButton : XCUIElement? = nil
    var clearButton : XCUIElement? = nil
    var resolveButton : XCUIElement? = nil
    var applyButton : XCUIElement? = nil
    var navigationBackToMenuButton : XCUIElement? = nil
    
    override func setUpWithError() throws {
 
        continueAfterFailure = false
        app.launch()
        
        loginButton = app.buttons["LoginButton"]
        menuArNoteButton = app/*@START_MENU_TOKEN@*/.buttons["arNoteButton"]/*[[".otherElements[\"menubackground\"].buttons[\"arNoteButton\"]",".buttons[\"arNoteButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        arActionsTitle = app/*@START_MENU_TOKEN@*/.staticTexts["ArActionsTitle"]/*[[".staticTexts[\"AR ACTIONS\"]",".staticTexts[\"ArActionsTitle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        resolveCodeTitle = app/*@START_MENU_TOKEN@*/.staticTexts["ResolveCodeTitle"]/*[[".staticTexts[\"RESOLVE CODE\"]",".staticTexts[\"ResolveCodeTitle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        arNoteTypeTitle = app/*@START_MENU_TOKEN@*/.staticTexts["ArNoteTypeTitle"]/*[[".staticTexts[\"ARNOTE TYPE\"]",".staticTexts[\"ArNoteTypeTitle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        arnoteTextTitle = app/*@START_MENU_TOKEN@*/.staticTexts["ArNoteTextTitle"]/*[[".staticTexts[\"ARNOTE TEXT:\"]",".staticTexts[\"ArNoteTextTitle\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        arNoteTextTextField = app.textFields["ArNoteTextTextField"]
        resolveCodeTextField = app.textFields["ResolveCodeTextField"]
        typePickerView = app.pickers["ArNoteTypePicker"]
        normalpickerWheel = app.pickers["ArNoteTypePicker"].pickerWheels["Normal"]
        warningpickerWheel = app.pickers["ArNoteTypePicker"].pickerWheels["Warning"]
        urgentpickerWheel = app.pickers["ArNoteTypePicker"].pickerWheels["Urgent"]
        cancelButton = app.buttons["CancelButton"]
        applyButton = app.buttons["ApplyButton"]
        filterButton = app/*@START_MENU_TOKEN@*/.buttons["FilterButton"]/*[[".buttons[\"compose\"]",".buttons[\"FilterButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        clearButton = app/*@START_MENU_TOKEN@*/.buttons["clearButton"]/*[[".buttons[\"CLEAR\"]",".buttons[\"clearButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        resolveButton = app/*@START_MENU_TOKEN@*/.buttons["resolveButton"]/*[[".buttons[\"RESOLVE\"]",".buttons[\"resolveButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        navigationBackToMenuButton = app.navigationBars["ArNoteThesisIOS.ArSceneView"].buttons["Back"]
    }

    override func tearDownWithError() throws{}

    func StartNavigatonToMyArScene()
    {
        loginButton?.tap()
        let loginPredicate = NSPredicate(format: "exists == 1")
        expectation(for: loginPredicate, evaluatedWith: menuArNoteButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        menuArNoteButton?.tap()
    }
    
    func testIfCancelButtonCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(clearButton!.exists)
        XCTAssertTrue(cancelButton!.isEnabled)
    }
    
    func testIfCancelButtonCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(cancelButton!.exists)
    }
    
    func testIfCancelButtonCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(cancelButton!.exists)
    }
    
    func testIfCancelButtonTitleIsCANCEL()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(cancelButton?.label, "CANCEL")
    }
    
    //2
    func testIfAcceptButtonCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(applyButton!.exists)
        XCTAssertTrue(applyButton!.isEnabled)
    }
    
    func testIfAcceptButtonCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(applyButton!.exists)
    }
    
    func testIfAcceptButtonCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(applyButton!.exists)
    }
    
    func testIfAcceptButtonTitleIsAPPLY()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(applyButton?.label, "APPLY")
    }
    
    func testIfResolveButtonCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(resolveButton!.exists)
        XCTAssertTrue(resolveButton!.isEnabled)
    }
    
    func testIfResolveButtonCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(resolveButton!.exists)
    }
    
    func testIfResolveButtonCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(resolveButton!.exists)
    }
    
    func testIfResolveButtonTitleIsRESOLVE()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(resolveButton?.label, "RESOLVE")
    }
    
    func testIfClearButtonCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(cancelButton!.exists)
        XCTAssertTrue(clearButton!.isEnabled)
    }
    
    func testIfClearButtonCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(clearButton!.exists)
    }
    
    func testIfClearButtonCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(clearButton!.exists)
    }
    
    func testIfClearButtonTitleIsCLEAR()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(clearButton?.label, "CLEAR")
    }
    //1
    func testIfArNoteTextTitleCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(arnoteTextTitle!.exists)
        XCTAssertTrue(arnoteTextTitle!.isEnabled)
    }
    
    func testIfArNoteTextTitleCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(arnoteTextTitle!.exists)
    }
    
    func testIfArNoteTextTitleCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(arnoteTextTitle!.exists)
    }
    
    func testIfArNoteTextTitleIsArNoteText()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(arnoteTextTitle?.label, "ARNOTE TEXT:")
    }
    
    //2
    func testArActionsIfTitleCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(arActionsTitle!.exists)
        XCTAssertTrue(arActionsTitle!.isEnabled)
    }
    
    func testIfArActionsTitleCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(arActionsTitle!.exists)
    }
    
    func testIfArActionsTitleCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(arActionsTitle!.exists)
    }
    
    func testIfArActionsTitleIsArActions()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(arActionsTitle?.label, "AR ACTIONS")
    }
    //3
    func testIfResolveCodeTitleCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(resolveCodeTitle!.exists)
        XCTAssertTrue(resolveCodeTitle!.isEnabled)
    }
    
    func testIfResolveCodeTitleCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(resolveCodeTitle!.exists)
    }
    
    func testIfResolveCodeTitleCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(resolveCodeTitle!.exists)
    }
    
    func testIfResolveCodeTitleIsResolveCode()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(resolveCodeTitle?.label, "RESOLVE CODE")
    }
    
    //4
    func testIfArNoteTypeTitleCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(arNoteTypeTitle!.exists)
        XCTAssertTrue(arNoteTypeTitle!.isEnabled)
    }
    
    func testIfArNoteTypeTitleCannotBeSeenAfterAcceptButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(arNoteTypeTitle!.exists)
    }
    
    func testIfArNoteTypeTitleCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(arNoteTypeTitle!.exists)
    }
    
    func testIfArNoteTypeTitleIsARNOTETYPE()
    {
        StartNavigatonToMyArScene()
        XCTAssertEqual(arNoteTypeTitle?.label, "ARNOTE TYPE")
    }
    
    func testIfArNoteTextFieldCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(arNoteTextTextField!.exists)
        XCTAssertTrue(arNoteTextTextField!.isEnabled)
    }
    
    func testIfArNoteTextFieldCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(arNoteTextTextField!.exists)
    }
    
    func testIfArNoteTextFieldCannotBeSeenAfterApplyButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(arNoteTextTextField!.exists)
    }
    
    func testIfResolveCodeTextFieldCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(resolveCodeTextField!.exists)
        XCTAssertTrue(resolveCodeTextField!.isEnabled)
    }
    
    func testIfResolveCodeTextFieldCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(resolveCodeTextField!.exists)
    }
    
    func testIfResolveCodeTextFieldCannotBeSeenAfterApplyButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(resolveCodeTextField!.exists)
    }
    
    func testIfTypePickerCanBeSeen()
    {
        StartNavigatonToMyArScene()
        XCTAssert(typePickerView!.exists)
        XCTAssertTrue(typePickerView!.isEnabled)
    }
    
    func testIfTypePickerCannotBeSeenAfterCancelButtonPress()
    {
        StartNavigatonToMyArScene()
        cancelButton?.tap()
        XCTAssertFalse(typePickerView!.exists)
    }
    
    func testIfTypePickerCannotBeSeenAfterApplyButtonPress()
    {
        StartNavigatonToMyArScene()
        applyButton?.tap()
        XCTAssertFalse(typePickerView!.exists)
    }
}
