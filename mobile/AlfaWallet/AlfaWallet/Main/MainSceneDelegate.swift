//
//  MainSceneDelegate.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import Foundation

public protocol MainSceneDelegate: AnyObject {
    func showAddCardView()
    func showHiddenCards()
    func showCardDetails(card: Card)
}
