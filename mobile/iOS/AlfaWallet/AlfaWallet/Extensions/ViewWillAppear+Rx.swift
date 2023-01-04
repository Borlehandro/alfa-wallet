//
//  ViewWillAppear+Rx.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 05.12.2022.
//

import Foundation
import RxSwift

extension Reactive where Base: UIView {
    var willMoveToWindow: Observable<Bool> {
        return self.sentMessage(#selector(Base.willMove(toWindow:)))
            .map({ $0.filter({ !($0 is NSNull) }) })
            .map({ $0.isEmpty == false })
    }
    var viewWillAppear: Observable<Void> {
        return self.willMoveToWindow
            .filter({ $0 })
            .map({ _ in Void() })
    }
    var viewWillDisappear: Observable<Void> {
        return self.willMoveToWindow
            .filter({ !$0 })
            .map({ _ in Void() })
    }
}
