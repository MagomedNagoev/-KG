//
//  MainViewUITest.swift
//  Курсы валют KGUITests
//
//  Created by Нагоев Магомед on 01.06.2022.
//

import XCTest

class MainViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    func testCurrencyView() {
        var checkNumberString1 = "5000000000000000000000000000000"
        let checkNumberString2 = "10000"
        
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].buttons["Курсы валют"].tap()
        
        let picker = app.pickers["Picker"]
        let firstCurrencyView = app.otherElements["FirstCurrencyView"]
        let secondCurrencyView = app.otherElements["SecondCurrencyView"]

        let firstCurrencyViewTF = firstCurrencyView.textFields["SumTextField"]
        let secondCurrencyViewTF = secondCurrencyView.textFields["SumTextField"]

        XCTAssertEqual(firstCurrencyViewTF.value as! String, "0,00")
        XCTAssertEqual(secondCurrencyViewTF.value as! String, "0,00")

        firstCurrencyViewTF.tap()
        firstCurrencyViewTF.typeText(checkNumberString1)
        XCTAssertNotEqual(firstCurrencyViewTF.value as! String, checkNumberString1)
        XCTAssertNotEqual(secondCurrencyViewTF.value as! String, "0,00")

        checkNumberString1 = "500 000 000,00"
        XCTAssertEqual(firstCurrencyViewTF.value as! String, checkNumberString1)

        secondCurrencyViewTF.tap()
        secondCurrencyViewTF.typeText(checkNumberString2)
        XCTAssertEqual(secondCurrencyViewTF.value as! String, "100,00")
        XCTAssertNotEqual(firstCurrencyViewTF.value as! String, checkNumberString1)

        firstCurrencyViewTF.tap()
        firstCurrencyViewTF.typeText(checkNumberString2)
        checkNumberString1 = secondCurrencyViewTF.value as! String
        app.buttons["SwipeButton"].tap()

        XCTAssertEqual(firstCurrencyViewTF.value as! String, "100,00")
        XCTAssertNotEqual(secondCurrencyViewTF.value as! String, checkNumberString1)
        
        checkNumberString1 = secondCurrencyViewTF.value as! String
        
        firstCurrencyView.buttons["ActiveTextFieldButton"].tap()
        picker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Евро")
        
        XCTAssertEqual(firstCurrencyViewTF.value as! String, "100,00")
        XCTAssertNotEqual(secondCurrencyViewTF.value as! String, checkNumberString1)
        
        picker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Киргизский сом")
        
        XCTAssertEqual(firstCurrencyViewTF.value as! String, "100,00")
        XCTAssertEqual(secondCurrencyViewTF.value as! String, checkNumberString1)
    }
    
    func testTableMainView() {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars["Tab Bar"].buttons["Курсы валют"].tap()
        
        XCTAssert(app.tables.cells.element(boundBy: 0).images.element(boundBy: 0).exists)
        XCTAssert(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 0).exists)
        XCTAssert(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 1).exists)
        XCTAssert(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 2).exists)
        XCTAssert(app.tables.cells.count > 0 && app.tables.cells.count < 7)
        
    }
}
