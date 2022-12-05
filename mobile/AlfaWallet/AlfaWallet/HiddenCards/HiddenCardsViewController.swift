//
//  HiddenCardsViewController.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit
import SnapKit
import RxSwift

public final class HiddenCardsViewController: UIViewController {

// MARK: - Public Properties

    var viewModel: HiddenCardsViewModel!
    var disposeBag: DisposeBag! = DisposeBag()

// MARK: - Private Properties

    private var titleCanTransitionToLarge = false
    private var titleCanTransitionToSmall = true

    private var cards: [Card] = [] {
        didSet {
            cardsCollectionView.reloadData()
        }
    }

    private lazy var backgroundView: UIImageView = {
        let background = UIImageView()
        background.image = Constants.backgroundImage
        background.contentMode = .scaleToFill

        return background
    }()

    private lazy var cardsCollectionView: UICollectionView = {
        let flowLayout = CardsOverlappingLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 1

        flowLayout.sectionInset = .init(
            top: Constants.horizontalSpacing,
            left: Constants.horizontalSpacing,
            bottom: Constants.buttonHeight + Constants.horizontalSpacing,
            right: Constants.horizontalSpacing
        )

        flowLayout.itemSize = CGSize(
            width: Constants.Cell.width,
            height: Constants.Cell.height
        )

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(
            CardCell.self,
            forCellWithReuseIdentifier: CardCell.reuseID
        )

        return collectionView
    }()

//MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
        setupUI()
    }
}

private extension HiddenCardsViewController {
    func setupUI() {
        setupNavBar()
        addSubviews()
        setupConstraints()
    }

    func setupNavBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

    func addSubviews() {
        [
            backgroundView,
            cardsCollectionView,
        ].forEach {
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        cardsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    func setupOutput() {
        guard let viewModel = viewModel else { return }

        let input = HiddenCardsViewModel.Input(
            showCardDetails: cardsCollectionView.rx.itemSelected,
            disposeBag: disposeBag
        )

        viewModel.transform(
            input,
            outputHandler: setupInput(input:)
        )
    }

    func setupInput(input: HiddenCardsViewModel.Output) {
        input.cards
            .subscribe(onNext: { cards in
                self.cards = cards
            })
            .disposed(by: disposeBag)
    }
}

extension HiddenCardsViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if titleCanTransitionToLarge && scrollView.contentOffset.y <= 0 {
            UIView.animate(withDuration: 1) {
                self.navigationItem.largeTitleDisplayMode = .always
            }
            titleCanTransitionToLarge = false
            titleCanTransitionToSmall = true
        }
        else if titleCanTransitionToSmall && scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 1) {
                self.navigationItem.largeTitleDisplayMode = .never
            }
            titleCanTransitionToLarge = true
            titleCanTransitionToSmall = false
        }
    }
}

//MARK: - CollectionView

extension HiddenCardsViewController: UICollectionViewDelegateFlowLayout {

}

extension HiddenCardsViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return cards.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let props: CardCell.Props = .init(card: cards[indexPath.row])

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CardCell.reuseID,
            for: indexPath
        ) as! CardCell
        cell.render(props: props)

        return cell
    }

}

//MARK: - Constants

private extension HiddenCardsViewController {
    enum Constants {
        static let title: String = "Скрытые карты"
        static let backgroundImage: UIImage? = UIImage(named: "Background")

        static let horizontalSpacing: CGFloat = 18.0
        static let buttonHeight: CGFloat = 50.0

        enum Cell {
            static let width: CGFloat = UIScreen.main.bounds.width - horizontalSpacing * 2
            static let height: CGFloat = (width / 339.0) * 192.0
        }
    }
}

