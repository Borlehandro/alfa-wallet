//
//  MainViewAssembly.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 03.12.2022.
//

import UIKit

enum MainAssembly {
    static func assemblyScene(
        sceneDelegate: MainCoordinator,
        network: NetworkUseCase,
        storage: CardsStorage
    ) -> MainViewController {
        let viewController = MainViewController()
        let viewModel = MainViewModel(
            sceneDelegate: sceneDelegate,
            storage: storage,
            network: network
        )
        viewController.viewModel = viewModel

        return viewController
    }
}
