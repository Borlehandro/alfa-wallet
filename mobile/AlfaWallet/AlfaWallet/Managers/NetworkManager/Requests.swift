//
//  Request.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 08.12.2022.
//

import Foundation

// MARK: - Request
struct fetchRequest: Codable {
    let base: Base
}

struct deleteRequest: Codable {
    let id: Int
    let base: Base
}

struct addRequest: Codable {
    let card: Card
    let base: Base
}

struct updateRequest: Codable {
    let card: Card
    let base: Base
}

// MARK: - Base
struct Base: Codable {
    let location: Location
    let deviceId: String
}

// MARK: - Location
struct Location: Codable {
    var longitude: Double
    var latitude: Double
}
