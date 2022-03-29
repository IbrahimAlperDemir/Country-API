//
//  Storable.swift
//  Countries
//
//  Created by Alper Demir on 28.03.2022.
//

import Foundation

protocol Retrievable {
  func retrieveCodable<T: Codable>(with key: StorageKey) -> T?
}

protocol Storable {
  func storeCodable<T: Codable>(with key: StorageKey, value: T)
}

typealias LocalStoreProtocol = Retrievable & Storable
