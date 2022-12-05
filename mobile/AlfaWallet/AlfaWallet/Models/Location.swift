//
//  Location.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import Foundation

public struct Location {
    var longitude: Double { Double(LocationManager.shared.currentLocation?.coordinate.longitude ?? 0.0) }
    var latitude: Double { Double(LocationManager.shared.currentLocation?.coordinate.latitude ?? 0.0) }
}
