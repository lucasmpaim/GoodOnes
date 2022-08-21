//
//  GeneralStateRepositoryTests.swift
//  GoodOnesTests
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import XCTest
@testable import GoodOnes


final class GeneralStateRepositoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        GeneralStateRepositoryTests.clearUserDefaults()
    }
    
    override class func tearDown() {
        super.tearDown()
        clearUserDefaults()
    }
    
    func test_saveUserFinishedOnboarding_saveCorrectlyOnUserDefaults() {
        //given
        let sut = GeneralStateRepository()
        
        // when
        sut[.tutorialIsDone] = true
        
        // then
        XCTAssertTrue(sut[.tutorialIsDone])
    }
    
}

extension GeneralStateRepositoryTests {
    class func clearUserDefaults() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
    }
}
