//
//  AddCardViewModel.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation
import RxCocoa
import RxSwift

public final class AddCardViewModel: ViewModel {

    private weak var network: NetworkUseCase?
    private weak var storage: CardsStorage?
    private weak var sceneDelegate: AddCardSceneDelegate?

    // MARK: - Private Properties

    private var newCardName: String = ""
    private var newCardBarcode: String = ""

    // MARK: - Internal Properties

    public struct Input {
        let cardName: ControlProperty<String?>
        let cardBarcode: ControlProperty<String?>
        let saveTapped: ControlEvent<Void>
        let disposeBag: DisposeBag
    }

    public struct Output { }

    // MARK: - Lifecycle

    init(
        sceneDelegate: AddCardSceneDelegate,
        network: NetworkUseCase,
        storage: CardsStorage
    ) {
        self.sceneDelegate = sceneDelegate
        self.network = network
        self.storage = storage
    }

    // MARK: - Internal Methods

    public func transform(
        _ input: Input,
        outputHandler: (Output) -> Void
    ) {

        let output = Output()
        outputHandler(output)

        input.disposeBag.insert([
            input.saveTapped
                .subscribe(onNext: { [weak self] in
                    self?.network?.addCard(
                        name: self?.newCardName ?? "",
                        barcode: self?.newCardBarcode ?? ""
                    )
                    self?.sceneDelegate?.closeView()
                }),

            input.cardName
                .subscribe(onNext: { name in
                    self.newCardName = name ?? ""
                }),

            input.cardBarcode
                .subscribe(onNext: { barcode in
                    self.newCardBarcode = barcode ?? ""
                })
        ])
    }
}

