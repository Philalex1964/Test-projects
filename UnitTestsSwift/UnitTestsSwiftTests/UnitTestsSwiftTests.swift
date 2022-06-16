//
//  UnitTestsSwiftTests.swift
//  UnitTestsSwiftTests
//
//  Created by Aleksandar Filipov on 6/15/22.
//

import XCTest
@testable import UnitTestsSwift

class UnitTestsSwiftTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
    }
    
    func testWordCountsAreCorrect() {
        let playData = PlayData()
        //        XCTAssertEqual(playData.wordCounts["home"], 174, "Home does not appear 174 times")
        //        XCTAssertEqual(playData.wordCounts["fun"], 4, "Fun does not appear 4 times")
        //        XCTAssertEqual(playData.wordCounts["mortal"], 41, "Mortal does not appear 41 times")
        XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home does not appear 174 times")
        XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Fun does not appear 4 times")
        XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Mortal does not appear 41 times")
    }
    
    func testWordsLoadQuickly() {
        measure {
            _ = PlayData()
        }
    }
    
    func testUserFilterWorks() {
        let playData = PlayData()
        
        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495, "100 times repeated words should be 495")
        
        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55, "1000 times repeated words should be 55")
        
        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1, "10000 times repeated words should be 1")
        
        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56, "Test does not appear 56 times")
        
        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7, "Swift does not appear 7 times")
        
        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0, "Objective should not appear")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            _ = PlayData()
        }
    }
    
}
