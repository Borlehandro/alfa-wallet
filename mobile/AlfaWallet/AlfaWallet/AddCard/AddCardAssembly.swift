//
//  AddCardAssembly.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

enum AddCardAssembly {
    static func assemblyScene(
        sceneDelegate: AddCardSceneDelegate,
        network: NetworkUseCase,
        storage: CardsStorage
    ) -> AddCardViewController {
        let viewController = AddCardViewController()
        let viewModel = AddCardViewModel(
            sceneDelegate: sceneDelegate,
            network: network,
            storage: storage
        )
        viewController.viewModel = viewModel

        return viewController
    }
}
