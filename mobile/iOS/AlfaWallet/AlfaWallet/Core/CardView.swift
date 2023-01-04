//
//  CardView.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation
import UIKit
import SnapKit

public class CardView: UIView {

// MARK: - Private Properties

    private lazy var barcodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .gray
        label.textAlignment = .center

        return label
    }()

    private lazy var barcodeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit

        return view
    }()

// MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

// MARK: - Internal Methods

    func render(props: Props) {
        barcodeLabel.text = props.barcode
        barcodeImageView.image = UIImage(barcode: props.barcode)
    }
}

// MARK: - Private Methods

private extension CardView {
    func setupUI() {
        addSubviews()
        setupConstraints()

        backgroundColor = .white
        layer.cornerRadius = 20.0
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 2.0
        clipsToBounds = true
    }

    func addSubviews() {
        [
            barcodeLabel,
            barcodeImageView,
        ].forEach {
            addSubview($0)
        }
    }

    func setupConstraints() {

        barcodeImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(45.0)
            $0.top.equalToSuperview().inset(45.0)
            $0.height.equalTo(88.0)
        }

        barcodeLabel.snp.makeConstraints {
            $0.right.left.equalToSuperview().inset(Constants.horizontalSpacing)
            $0.top.equalTo(barcodeImageView.snp.bottom).offset(6.0)
            $0.height.equalTo(18.0)
        }

        self.snp.makeConstraints {
            $0.width.equalTo(Constants.width)
            $0.height.equalTo(Constants.height)
        }
    }
}

// MARK: - Props

extension CardView {
    struct Props {
        let barcode: String
    }
}

// MARK: - Constants

private extension CardView {
    enum Constants {
        static let horizontalSpacing: CGFloat = 18.0
        static let width: CGFloat = UIScreen.main.bounds.width - horizontalSpacing * 2
        static let height: CGFloat = (width / 339.0) * 192.0
    }
}

