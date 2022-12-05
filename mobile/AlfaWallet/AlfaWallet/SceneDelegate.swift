//
//  SceneDelegate.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController = .init()
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let scene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: scene)
            window.overrideUserInterfaceStyle = .dark
            window.rootViewController = navigationController

            let networkUseCase: NetworkUseCase = NetworkUseCaseImpl()
            let cardsStorage: CardsStorage = CardsStorageImpl.shared

            coordinator = MainCoordinator(
                navigation: navigationController,
                storage: cardsStorage,
                network: networkUseCase
            )
            coordinator?.startMainUseCase()

            self.window = window
            self.window?.makeKeyAndVisible()
        }
    }
}
