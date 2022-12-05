//
//  Updatable.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation

@propertyWrapper struct Updatable {
    var wrappedValue: Card {
        didSet {
            //NetworkUseCase.shared.updateCard(with: wrappedValue)
            print("Card changed")
        }
    }

    init(wrappedValue: Card) {
        self.wrappedValue = wrappedValue
    }
}
