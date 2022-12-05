//
//  CardDetailsViewController.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit
import SnapKit
import RxSwift

public final class CardDetailsViewController: UIViewController {

// MARK: - Public Properties

    var viewModel: CardsDetailsViewModel!
    var disposeBag: DisposeBag! = DisposeBag()

// MARK: - Private Properties

    private lazy var backgroundView: UIImageView = {
        let background = UIImageView()
        background.image = Constants.backgroundImage
        background.contentMode = .scaleToFill

        return background
    }()

    private lazy var cardView: CardView = .init()

    private lazy var hideView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true

        return view
    }()

    private lazy var miniatureView: UIImageView = {
        let view = UIImageView()
        view.frame.size = CGSize(width: 40.0, height: 25.0)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CardMiniature")

        return view
    }()

    private lazy var hideLabel: UIView = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Скрыть карту"

        return label
    }()

    private lazy var hideSwitch: UISwitch = .init()

//MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
        setupUI()
    }
}

private extension CardDetailsViewController {
    func setupUI() {
        setupNavBar()
        addSubviews()
        setupConstraints()
    }

    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

    func addSubviews() {
        [
            backgroundView,
            cardView,
            hideView,
        ].forEach {
            view.addSubview($0)
        }

        [
            miniatureView,
            hideLabel,
            hideSwitch,
        ].forEach {
            hideView.addSubview($0)
        }
    }

    func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        cardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
        }

        hideView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            $0.top.equalTo(cardView.snp.bottom).offset(14.0)
            $0.height.equalTo(62.0)
        }

        miniatureView.snp.makeConstraints {
            $0.left.equalTo(hideView.snp.left).offset(16.0)
            $0.centerY.equalTo(hideView.snp.centerY)
            $0.height.equalTo(25.0)
            $0.width.equalTo(40.0)
        }

        hideLabel.snp.makeConstraints {
            $0.left.equalTo(miniatureView.snp.right).offset(13.0)
            $0.centerY.equalTo(hideView.snp.centerY)
        }

        hideSwitch.snp.makeConstraints {
            $0.left.equalTo(hideLabel.snp.right).offset(13.0)
            $0.right.equalTo(hideView.snp.right).offset(-16.0)
            $0.centerY.equalTo(hideView.snp.centerY)
        }
    }

    func setupOutput() {
        guard let viewModel = viewModel else { return }

        let input = CardsDetailsViewModel.Input(
            isNeedToHide: hideSwitch.rx.controlEvent(.valueChanged).withLatestFrom(hideSwitch.rx.value),
            disposeBag: disposeBag
        )

        viewModel.transform(
            input,
            outputHandler: setupInput(input:)
        )
    }

    func setupInput(input: CardsDetailsViewModel.Output) {
        input.title
            .bind(to: rx.title)
            .disposed(by: disposeBag)

        input.barcode
            .subscribe(onNext: { barcode in
                self.cardView.render(props: .init(barcode: String(barcode)))
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Constants

private extension CardDetailsViewController {
    enum Constants {
        static let backgroundImage: UIImage? = UIImage(named: "Background")

        static let horizontalSpacing: CGFloat = 18.0
        static let buttonHeight: CGFloat = 50.0

        enum Cell {
            static let width: CGFloat = UIScreen.main.bounds.width - horizontalSpacing * 2
            static let height: CGFloat = (width / 339.0) * 192.0
        }
    }
}


