//
//  MainViewModel.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import Foundation
import RxCocoa
import RxSwift

public final class MainViewModel: ViewModel {

    // MARK: - Private Properties

    private var cards: [Card] = []

    // MARK: - Internal Properties

    weak var sceneDelegate: MainSceneDelegate?
    weak var storage: CardsStorage?
    weak var network: NetworkUseCase?

    public struct Input {
        let viewWillAppear: Observable<Void>
        let addButtonTap: ControlEvent<Void>
        let showHiddenCards: ControlEvent<Void>
        let showCardDetails: ControlEvent<IndexPath>
        let disposeBag: DisposeBag
    }

    public struct Output {
        let cards: Observable<[Card]>
    }

    // MARK: - Lifecycle

    init(
        sceneDelegate: MainSceneDelegate? = nil,
        storage: CardsStorage,
        network: NetworkUseCase
    ) {
        self.network = network
        self.storage = storage
        self.sceneDelegate = sceneDelegate
    }

    // MARK: - Methods

    private func getCards() -> Observable<[Card]> {
        storage?.cards = (network?.fetchCards() ?? []).filter({ $0.isHidden == false })
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

            input.viewWillAppear
                .subscribe(onNext: {

                }),

            input.showCardDetails
                .subscribe(onNext: { index in
                    self.sceneDelegate?.showCardDetails(card: self.cards[index.row])
                }, onError: { error in
                    print("⚠️ \(error)")
                }),

            input.addButtonTap
                .subscribe(onNext: { [weak self] _ in
                    self?.sceneDelegate?.showAddCardView()
                }, onError: { error in
                    print("⚠️ \(error)")
                }),

            input.showHiddenCards
                .subscribe(onNext: { [weak self] _ in
                    self?.sceneDelegate?.showHiddenCards()
                }, onError: { error in
                    print("⚠️ \(error)")
                })
        ])
    }
}
