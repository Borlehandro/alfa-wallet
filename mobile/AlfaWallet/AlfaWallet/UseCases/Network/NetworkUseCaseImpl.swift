//
//  NetworkUseCaseImpl.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation

public final class NetworkUseCaseImpl: NetworkUseCase {

    var mockCards: [Card] = [
        Card(id: 1, name: "Lenta", barcode: "12345678", isHidden: true),
        Card(id: 2, name: "Магнит", barcode: "12345678", isHidden: false),
        Card(id: 3, name: "Lenta", barcode: "12345678", isHidden: true),
        Card(id: 4, name: "Магнит", barcode: "12345678", isHidden: false),
        Card(id: 5, name: "Lenta", barcode: "12345678", isHidden: true),
        Card(id: 6, name: "Магнит", barcode: "12345678", isHidden: false),
    ]

    public func addCard(name: String, barcode: String) -> [Card] {
        print("[⌘ NETWORK] add \(name)")

        return mockCards
    }

    public func deleteCard(id: Int)  -> [Card] {
        print("[⌘ NETWORK] delete with ID: \(id)")

        return mockCards
    }

    public func updateCard(card: Card) -> [Card] {
        print("[⌘ NETWORK] update \(card)")

        if let i = mockCards.firstIndex(where: {$0.id == card.id}) {
           mockCards[i] = card
        }

        return mockCards
    }

    public func fetchCards() -> [Card] {
        let currentLocation = Location()
        print("[⌘ NETWORK] long: \(currentLocation.longitude), lat: \(currentLocation.latitude)")

        return mockCards
    }
}
