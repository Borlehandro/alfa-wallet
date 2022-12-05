//
//  HiddenCardsSceneDelegate.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation

public protocol HiddenCardsSceneDelegate: AnyObject {
    func showCardDetails(card: Card)
}
