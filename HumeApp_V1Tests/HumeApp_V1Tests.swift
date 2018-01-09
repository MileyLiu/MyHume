//
//  HumeApp_V1Tests.swift
//  HumeApp_V1Tests
//
//  Created by MileyLiu on 29/9/17.
//  Copyright © 2017 MileyLiu. All rights reserved.
//

import XCTest
@testable import HumeApp_V1

class HumeApp_V1Tests: XCTestCase {
    
    var Weather: Weather!
    
    override func setUp() {
        super.setUp()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let kelvin = 277.0
        let expectedCelsius = 4
        XCTAssertEqual(expectedCelsius, kelvinToCelsius(kelvin: kelvin),"transfer Kelvin to Celsius failed")
        
//        let timeBucket = getTimeBucket()
//        let morningExp = "Morning"
//        let afternoonExp = "Afternoon"
//        let nightExp = "Night"
//        XCTAssertEqual(timeBucket, afternoonExp,"It is not morning now")

        let slipState = checkState(slip: "PRE/147552")
        let expState = "VIC"
        XCTAssertEqual(slipState, expState,"State is worng")
        
        let suburb = formatingSuburb(suburb: " Chester Hill ")
        let suburbExp = "Chester%20Hill"
        XCTAssertEqual(suburb, suburbExp,"Suburb formatting is worng")
        
        let date = changeUTCtoDate(UTCString: 1515466874)
        let dateExp = "09/01"
          XCTAssertEqual(date, dateExp,"date is worng")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
            
            
        }
    }
    
}
