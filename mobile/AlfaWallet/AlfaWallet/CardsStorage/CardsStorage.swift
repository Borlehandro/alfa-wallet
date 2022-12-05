//
//  CardsUseCase.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 05.12.2022.
//

import Foundation
import RxSwift

protocol CardsStorage: AnyObject {
    var cards: [Card] { get set }
}
