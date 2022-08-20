//
//  GeneralStateRepositoryTests.swift
//  GoodOnesTests
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import XCTest
@testable import GoodOnes


final class UserDefaultTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.resetStandardUserDefaults()
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
