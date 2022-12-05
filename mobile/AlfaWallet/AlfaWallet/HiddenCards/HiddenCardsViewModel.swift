//
//  HiddenCardsViewModel.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation
import RxCocoa
import RxSwift

public final class HiddenCardsViewModel: ViewModel {

    // MARK: - Private Properties
    private var cards: [Card] = []

    private weak var network: NetworkUseCase?
    private weak var storage: CardsStorage?
    private weak var sceneDelegate: HiddenCardsSceneDelegate?
    // MARK: - Internal Properties

    public struct Input {
        let showCardDetails: ControlEvent<IndexPath>
        let disposeBag: DisposeBag
    }

    public struct Output {
        let cards: Observable<[Card]>
    }

    // MARK: - Lifecycle

    init(
        sceneDelegate: HiddenCardsSceneDelegate? = nil,
        network: NetworkUseCase,
        storage: CardsStorage
    ) {
        self.sceneDelegate = sceneDelegate
        self.network = network
        self.storage = storage
    }

    // MARK: - Methods

    private func getCards() -> Observable<[Card]> {
        storage?.cards = (network?.fetchCards() ?? []).filter({ $0.isHidden == true })
        cards = storage?.cards ?? []
        return Observable.just(storage?.cards ?? [])
    }

    public func transform(
        _ input: Input,
        outputHandler: (Output) -> Void
    ) {
        let output = Output(cards: getCards())
        outputHandler(output)

        input.disposeBag.insert([
            input.showCardDetails
                .subscribe(onNext: { index in
                    self.sceneDelegate?.showCardDetails(card: self.cards[index.row])
                }, onError: { error in
                    print("⚠️ \(error)")
                }),
        ])
    }
}
