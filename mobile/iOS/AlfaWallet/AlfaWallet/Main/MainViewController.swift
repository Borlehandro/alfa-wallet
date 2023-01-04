//
//  ViewController.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import UIKit
import SnapKit
import RxSwift

public final class MainViewController: UIViewController {

// MARK: - Public Properties

    var viewModel: MainViewModel!
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

    private lazy var hiddenCardsButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.hiddenCardsTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .medium)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .white

        return button
    }()

    //Обёртка контейнера нужна здесь по причине того, что Rx не обрабатывает нажатие,
    //если в UIButton/UIControl содержится subview.
    private lazy var hiddenCardsButtonContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.layer.cornerRadius = 24.0
        container.clipsToBounds = true

        return container
    }()

    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)

        return blurView
    }()

    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.addImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.frame = CGRect(
            x: 0,
            y: 0,
            width: 30,
            height: 30
        )

        return button
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardsCollectionView.reloadData()
    }
}

private extension MainViewController {
    func setupUI() {
        setupNavBar()
        addSubviews()
        setupConstraints()
    }

    func setupNavBar() {
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.tabBarController?.tabBar.isHidden = true

        let addItem = UIBarButtonItem(customView: addCardButton)
        navigationItem.setRightBarButtonItems([addItem], animated: true)
    }

    func addSubviews() {
        [
            backgroundView,
            cardsCollectionView,
            hiddenCardsButtonContainerView,
        ].forEach {
            view.addSubview($0)
        }
        [
            blurView,
            hiddenCardsButton,
        ].forEach {
            hiddenCardsButtonContainerView.addSubview($0)
        }
    }

    func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        hiddenCardsButtonContainerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            $0.height.equalTo(Constants.buttonHeight)
            $0.bottom.equalToSuperview().inset(37.0)
        }

        hiddenCardsButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        cardsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    func setupOutput() {
        guard let viewModel = viewModel else { return }

        let input = MainViewModel.Input(
            viewWillAppear: view.rx.viewWillAppear,
            addButtonTap: addCardButton.rx.tap,
            showHiddenCards: hiddenCardsButton.rx.tap,
            showCardDetails: cardsCollectionView.rx.itemSelected,
            disposeBag: disposeBag
        )

        viewModel.transform(
            input,
            outputHandler: setupInput(input:)
        )
    }

    func setupInput(input: MainViewModel.Output) {
        input.cards
            .subscribe(onNext: { cards in
                self.cards = cards
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UIScrollViewDelegate {
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

extension MainViewController: UICollectionViewDelegateFlowLayout {

}

extension MainViewController: UICollectionViewDataSource {
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

private extension MainViewController {
    enum Constants {
        static let title: String = "Мои карты"
        static let backgroundImage: UIImage? = UIImage(named: "Background")
        static let addImage: UIImage? = UIImage(named: "AddCircle")
        static let hiddenCardsTitle: String = "Скрытые карты"

        static let horizontalSpacing: CGFloat = 18.0
        static let buttonHeight: CGFloat = 50.0

        enum Cell {
            static let width: CGFloat = UIScreen.main.bounds.width - horizontalSpacing * 2
            static let height: CGFloat = (width / 339.0) * 192.0
        }
    }
}
