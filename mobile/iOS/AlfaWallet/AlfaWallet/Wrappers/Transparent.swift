//
//  Transparent.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

@propertyWrapper struct Transparent {
    var wrappedValue: [UIColor] {
        didSet {
            wrappedValue = wrappedValue.map { $0.withAlphaComponent(0.1)}

        }
    }

    init(wrappedValue: [UIColor]) {
        self.wrappedValue = wrappedValue.map { $0.withAlphaComponent(0.1)}
    }
}
