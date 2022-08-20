//
//  GeneralStateRepository.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation

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
