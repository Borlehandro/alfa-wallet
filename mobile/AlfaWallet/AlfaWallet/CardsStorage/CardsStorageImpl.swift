//
//  CardsUseCaseImpl.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 05.12.2022.
//

import Foundation
import RxSwift

public final class CardsStorageImpl: CardsStorage {

    static let shared = CardsStorageImpl()

    var cards: [Card] = []
}
