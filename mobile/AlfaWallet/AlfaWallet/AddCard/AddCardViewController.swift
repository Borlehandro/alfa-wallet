//
//  AddCardViewController.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit
import SnapKit
import RxSwift

public final class AddCardViewController: UIViewController {

// MARK: - Public Properties

    var viewModel: AddCardViewModel!
    var disposeBag: DisposeBag! = DisposeBag()

// MARK: - Private Properties

    private lazy var backgroundView: UIImageView = {
        let background = UIImageView()
        background.image = Constants.backgroundImage
        background.contentMode = .scaleToFill

        return background
    }()

    private lazy var nameTextField: AlfaTextField = .init(title: "Название магазина")
    private lazy var barcodeTextField: AlfaTextField = .init(title: "Номер штрихкода на карте")

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .white

        return button
    }()

    //Обёртка контейнера нужна здесь по причине того, что Rx не обрабатывает нажатие,
    //если в UIButton/UIControl содержится subview.
    private lazy var saveButtonContainerView: UIView = {
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

//MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
        setupUI()
    }
}

private extension AddCardViewController {
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
            nameTextField,
            barcodeTextField,
            saveButtonContainerView,
        ].forEach {
            view.addSubview($0)
        }

        [
            blurView,
            saveButton,
        ].forEach {
            saveButtonContainerView.addSubview($0)
        }
    }

    func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            $0.height.equalTo(70.0)
        }

        barcodeTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(12.0)
            $0.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            $0.height.equalTo(70.0)
        }

        saveButtonContainerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.horizontalSpacing)
            $0.height.equalTo(Constants.buttonHeight)
            $0.bottom.equalToSuperview().inset(37.0)
        }

        saveButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupOutput() {
        guard let viewModel = viewModel else { return }

        let input = AddCardViewModel.Input(
            cardName: nameTextField.field.rx.text,
            cardBarcode: barcodeTextField.field.rx.text,
            saveTapped: saveButton.rx.tap,
            disposeBag: disposeBag
        )

        viewModel.transform(
            input,
            outputHandler: setupInput(input:)
        )
    }

    func setupInput(input: AddCardViewModel.Output) { }
}

//MARK: - Constants

private extension AddCardViewController {
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


