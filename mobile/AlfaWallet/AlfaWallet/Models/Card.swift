//
//  Card.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import Foundation

public struct Card: Decodable {
    let id: Int
    var name: String
    var barcode: String
    var isHidden: Bool
}
