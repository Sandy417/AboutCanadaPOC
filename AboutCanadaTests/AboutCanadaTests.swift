//
//  AboutCanadaTests.swift
//  AboutCanadaTests
//
//  Created by Sandeep on 19/05/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import XCTest
@testable import AboutCanada

class AboutCanadaTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
               
        let expectation = XCTestExpectation(description: "Download contents")
        
        let dropboxUrl = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
        
        let dataTask = URLSession.shared.dataTask(with: dropboxUrl) { (data, _, _) in
            
            XCTAssertNotNil(data, "No data was downloaded.")
            expectation.fulfill()
            
        }
        
        dataTask.resume()
        
        wait(for: [expectation], timeout: 10.0)
       
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
