//
//  MainCoordinator.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import Foundation
import UIKit

public final class MainCoordinator: NSObject, MainSceneDelegate, HiddenCardsSceneDelegate, AddCardSceneDelegate {
    private let navigation: UINavigationController
    private let networkUseCase: NetworkUseCase
    private let storage: CardsStorage

    init(
        navigation: UINavigationController,
        storage: CardsStorage,
        network: NetworkUseCase
    ) {
        self.navigation = navigation
        self.storage = storage
        self.networkUseCase = network

        super.init()
    }

    public func startMainUseCase() {
        let mainVC = MainAssembly.assemblyScene(
            sceneDelegate: self,
            network: networkUseCase,
            storage: storage
        )
        navigation.pushViewController(mainVC, animated: true)
    }

    public func showCardDetails(card: Card) {
        let cardVC = CardDetailsAssembly.assemblyScene(
            card: card,
            network: networkUseCase,
            storage: storage
        )
        navigation.pushViewController(cardVC, animated: true)
    }

    public func showAddCardView() {
        let addVC = AddCardAssembly.assemblyScene(
            sceneDelegate: self,
            network: networkUseCase,
            storage: storage
        )
        navigation.pushViewController(addVC, animated: true)
    }

    public func showHiddenCards() {
        let hiddenCardsVC = HiddenCardsAssembly.assemblyScene(
            sceneDelegate: self,
            network: networkUseCase,
            storage: storage
        )
        navigation.pushViewController(hiddenCardsVC, animated: true)
    }

    public func closeView() {
        navigation.popViewController(animated: true)
    }
}
