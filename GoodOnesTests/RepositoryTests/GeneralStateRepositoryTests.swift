//
//  GeneralStateRepositoryTests.swift
//  GoodOnesTests
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation
import XCTest
@testable import GoodOnes


enum GeneralState {
    enum BooleanFields: String, RawRepresentable {
        case tutorialIsDone
    }
}

protocol GeneralStateStorage {
    subscript(_ key: GeneralState.BooleanFields) -> Bool {get set}
}

final class GeneralStateRepository : GeneralStateStorage {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    
    subscript(key: GeneralState.BooleanFields) -> Bool {
        get {
            return userDefaults.bool(forKey: uniqueKey(for: key))
        }
        set {
            userDefaults.set(newValue, forKey: uniqueKey(for: key))
        }
    }
    
    private func uniqueKey<T: RawRepresentable>(for key: T) -> String {
        return "GeneralState_\(type(of: key))_\(key)"
    }
    
}

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
