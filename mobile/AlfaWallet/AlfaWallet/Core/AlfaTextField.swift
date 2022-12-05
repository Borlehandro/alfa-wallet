//
//  AlfaTextField.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit
import SnapKit

public class AlfaTextField: UIView {

// MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .white
        label.textAlignment = .left

        return label
    }()

    private(set) lazy var field: UITextField = {
        let field = UITextField()
        field.tintColor = .red

        return field
    }()

// MARK: - Lifecycle

    public init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension AlfaTextField {
    func setupUI() {
        addSubviews()
        setupConstraints()

        backgroundColor = .darkGray
        layer.cornerRadius = 12.0
        clipsToBounds = true
    }

    func addSubviews() {
        [
            titleLabel,
            field,
        ].forEach {
            addSubview($0)
        }
    }

    func setupConstraints() {

        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().offset(12.0)
            $0.height.equalTo(20.0)
        }

        field.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.bottom.equalToSuperview().inset(12.0)
        }

        self.snp.makeConstraints {
            $0.width.equalTo(Constants.width)
            $0.height.equalTo(Constants.height)
        }
    }
}

// MARK: - Constants

private extension AlfaTextField {
    enum Constants {
        static let horizontalSpacing: CGFloat = 18.0
        static let width: CGFloat = UIScreen.main.bounds.width - horizontalSpacing * 2
        static let height: CGFloat = (width / 339.0) * 62.0
    }
}


