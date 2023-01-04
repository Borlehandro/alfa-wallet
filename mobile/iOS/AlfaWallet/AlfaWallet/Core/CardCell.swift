//
//  CardCell.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 03.12.2022.
//

import Foundation
import UIKit
import SnapKit

public class CardCell: UICollectionViewCell {

// MARK: - Public Properties

    public static var reuseID: String { Constants.cellID }

// MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        label.textAlignment = .right

        return label
    }()

    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = makeRandomBackgroundColor()

        return blurView
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
        titleLabel.text = props.card.name
    }
}

// MARK: - Private Methods

private extension CardCell {
    func setupUI() {
        addSubviews()
        setupConstraints()

        layer.cornerRadius = 20.0
        clipsToBounds = true

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(
            origin: CGPointZero,
            size: frame.size
        )

        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.gray.cgColor,
        ]

        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 20.0
        ).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        layer.addSublayer(gradient)
    }

    func addSubviews() {
        [
            blurView,
            titleLabel,
        ].forEach {
            addSubview($0)
        }
    }

    func setupConstraints() {
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(18.0)
            $0.width.equalToSuperview().dividedBy(2)
        }
    }

    func makeRandomBackgroundColor() -> UIColor {
        @Transparent var colors: [UIColor] = [.red, .cyan, .green, .blue, .yellow]

        return colors.randomElement() ?? .clear
    }
}

// MARK: - Props

extension CardCell {
    struct Props {
        let card: Card
    }
}

// MARK: - Constants

private extension CardCell {
    enum Constants {
        static let cellID: String = "Card"
        static let horizontalSpacing: CGFloat = 18.0
        static let width: CGFloat = UIScreen.main.bounds.width - horizontalSpacing * 2
        static let height: CGFloat = (width / 339.0) * 192.0
    }
}

