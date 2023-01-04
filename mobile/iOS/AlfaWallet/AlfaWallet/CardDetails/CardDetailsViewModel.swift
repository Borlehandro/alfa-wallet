//
//  CardDetailsViewModel.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation
import RxCocoa
import RxSwift

public final class CardsDetailsViewModel: ViewModel {

    // MARK: - Private Properties

    private weak var network: NetworkUseCase?
    private weak var storage: CardsStorage?

    private var card: Card

    // MARK: - Internal Properties

    public struct Input {
        let isNeedToHide: Observable<ControlProperty<Bool>.Element>
        let disposeBag: DisposeBag
    }

    public struct Output {
        let title: Observable<String>
        let barcode: Observable<String>
        let isHidden: Observable<Bool>
    }

    // MARK: - Lifecycle

    init(
        card: Card,
        network: NetworkUseCase,
        storage: CardsStorage
    ) {
        self.card = card
        self.network = network
        self.storage = storage
    }

    // MARK: - Methods

    private func updateCard(card: Card) {
        storage?.cards = network?.updateCard(card: card) ?? []
    }

    public func transform(
        _ input: Input,
        outputHandler: (Output) -> Void
    ) {
        let output = Output(
            title: Observable.just(card.name),
            barcode: Observable.just(card.barcode),
            isHidden: Observable.just(card.isHidden)
        )
        outputHandler(output)

        input.disposeBag.insert([
            input.isNeedToHide
                .subscribe(onNext: { isHidden in
                    self.card.isHidden = isHidden
                    self.updateCard(card: self.card)
                })
        ])
    }
}

