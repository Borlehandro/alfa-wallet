//
//  CardDetailsAssembly.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

enum CardDetailsAssembly {
    static func assemblyScene(
        card: Card,
        network: NetworkUseCase,
        storage: CardsStorage
    ) -> CardDetailsViewController {
        let viewController = CardDetailsViewController()
        let viewModel = CardsDetailsViewModel(
            card: card,
            network: network,
            storage: storage
        )
        viewController.viewModel = viewModel

        return viewController
    }
}
