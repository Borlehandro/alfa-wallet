//
//  ViewModel.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 02.12.2022.
//

import Foundation

public protocol ViewModel {
    /// Входящие от `View` евенты
    associatedtype Input
    /// Исходящие от `ViewModel` увенты
    associatedtype Output

    func transform(_ input: Input, outputHandler: @escaping (_ output: Output) -> Void)

}
