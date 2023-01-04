//
//  NetworkUseCaseImpl.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation

public final class NetworkUseCaseImpl: NetworkUseCase {

    let network = NetworkManager()

    var mockCards: [Card] = [
        Card(id: 1, name: "Lenta", barcode: "12345678", isHidden: true),
        Card(id: 2, name: "Магнит", barcode: "12345678", isHidden: false),
        Card(id: 3, name: "Lenta", barcode: "12345678", isHidden: true),
        Card(id: 4, name: "Магнит", barcode: "12345678", isHidden: false),
        Card(id: 5, name: "Lenta", barcode: "12345678", isHidden: true),
        Card(id: 6, name: "Магнит", barcode: "12345678", isHidden: false),
    ]

    public func addCard(name: String, barcode: String) -> [Card] {
        var cards: [Card] = []
        let newCard: Card = .init(
            id: -1,
            name: name,
            barcode: barcode,
            isHidden: false
        )

        network.addCard(
            card: newCard,
            completion: { result in
                switch result {
                case .success(let response):
                    cards = response.cards
                case .failure(let error):
                    print(error)
                }
            })

        return cards
    }

    public func deleteCard(id: Int)  -> [Card] {
        var cards: [Card] = []

        network.deleteCard(
            cardID: id,
            completion: { result in
                switch result {
                case .success(let response):
                    cards = response.cards
                case .failure(let error):
                    print(error)
                }
            })

        return cards
    }

    public func updateCard(card: Card) -> [Card] {
        print("[⌘ NETWORK] update \(card)")

        if let i = mockCards.firstIndex(where: {$0.id == card.id}) {
           mockCards[i] = card
        }

        return mockCards
    }

    public func fetchCards() -> [Card] {
        var cards: [Card] = []

        network.fetchCardsList { result in
            switch result {
            case .success(let response):
                cards = response.cards
            case .failure(let error):
               print(error)
            }
        }

        return cards
    }
}
