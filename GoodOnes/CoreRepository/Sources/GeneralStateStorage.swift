//
//  GeneralStateStorage.swift
//  GoodOnes
//
//  Created by Lucas Paim on 20/08/22.
//

import Foundation

protocol GeneralStateStorage {
    subscript(_ key: GeneralState.BooleanFields) -> Bool {get set}
}
