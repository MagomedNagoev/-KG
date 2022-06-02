//
//  BalancesViewUITests.swift
//  Курсы валют KGUITests
//
//  Created by Нагоев Магомед on 01.06.2022.
//

import XCTest

class BalancesViewUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    override func setUp() {
        app.launch()
        app.tabBars["Tab Bar"].buttons["Мои счета"].tap()
    }

    func testSwipeImage() {
        
        var valuteFullNameLabelValue = ""
        var totalSumValue = ""
        let backButton = app.buttons["Back"]
        let forwardButton = app.buttons["Forward"]
        
        let image = app.images["CountryImage"]
        let valuteFullNameLabel = app.staticTexts["ValuteFullNameLabel"]
        let totalSum = app.staticTexts["TotalSum"]
        
        valuteFullNameLabelValue = valuteFullNameLabel.label
        totalSumValue = totalSum.label
        
        image.swipeLeft()
        XCTAssertNotEqual(valuteFullNameLabel.label, valuteFullNameLabelValue)
        XCTAssertNotEqual(totalSum.label, totalSumValue)
        
        backButton.tap()
        
        XCTAssertEqual(valuteFullNameLabel.label, valuteFullNameLabelValue)
        XCTAssertEqual(totalSum.label, totalSumValue)
        
        forwardButton.tap()
        forwardButton.tap()
        image.swipeRight()
        XCTAssertNotEqual(valuteFullNameLabel.label, valuteFullNameLabelValue)
        XCTAssertNotEqual(totalSum.label, totalSumValue)
    }
    
    func testAddRateInTable() {
        let addButton = app.navigationBars["Курсы_валют_KG.BalancesView"].buttons["Add"]
        let table = app.tables
        let deleteButton = table.buttons["Delete"]
        var tableCount = 0
        let totalSum = app.staticTexts["TotalSum"]
        let totalSumValue = totalSum.label
        let queue = DispatchQueue(label: "KG")
        
        tableCount = app.tables.cells.count
        
        addButton.tap()
        table.staticTexts["Киргизский сом"].tap()
        XCTAssertNotEqual(tableCount, app.tables.cells.count)
        table.cells.element(boundBy: 0).swipeLeft()
        deleteButton.tap()
        
        
        
        XCTAssertEqual(tableCount, app.tables.cells.count)
        queue.sync {
            tableCount = self.app.tables.cells.count - 1
        }
        
        XCTAssertNotEqual(tableCount, app.tables.cells.count)
        table.cells.element(boundBy: tableCount).textFields["AmountTextField"].tap()
        table.cells.element(boundBy: tableCount).textFields["AmountTextField"].typeText("10000")
        
        
        XCTAssertNotEqual(totalSumValue, totalSum.label)
    }
    
}
