//
//  Responses.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 07.12.2022.
//

import Foundation

    // MARK: - Response (of characters, comics, etc.)
struct Response<T: Codable>: Codable {
    let cards: [T]
}
