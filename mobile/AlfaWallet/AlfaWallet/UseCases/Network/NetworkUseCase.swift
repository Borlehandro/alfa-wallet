//
//  NetworkUseCase.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation

public protocol NetworkUseCase: AnyObject {
    func addCard(name: String, barcode: String) -> [Card]
    func deleteCard(id: Int) -> [Card]
    func updateCard(card: Card) -> [Card]
    func fetchCards() -> [Card]
}
