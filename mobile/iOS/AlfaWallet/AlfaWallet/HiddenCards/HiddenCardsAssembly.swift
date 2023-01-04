//
//  HiddenCardsAssembly.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

enum HiddenCardsAssembly {
    static func assemblyScene(
        sceneDelegate: HiddenCardsSceneDelegate,
        network: NetworkUseCase,
        storage: CardsStorage
    ) -> HiddenCardsViewController {
        let viewController = HiddenCardsViewController()
        let viewModel = HiddenCardsViewModel(
            sceneDelegate: sceneDelegate,
            network: network,
            storage: storage
        )
        viewController.viewModel = viewModel

        return viewController
    }
}
