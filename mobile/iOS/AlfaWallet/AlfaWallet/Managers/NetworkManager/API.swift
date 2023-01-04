//
//  API.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 07.12.2022.
//

import Foundation
import Moya

enum API {
    case cards
    case addCard(card: Card)
    case updateCard(card: Card)
    case deleteCard(id: Int)
}

// MARK: - Extensions

extension API: TargetType {
    var headers: [String : String]? {
        return nil
    }

    var url: String {
        "http://84.201.143.76:8080/"
    }

    var base: String { url }

    var baseURL: URL {
        guard let url = URL(string: base) else { fatalError() }
        return url
    }

    var path: String {
        switch self {
        case .cards:
            return "cards/all"

        case .addCard(card: _):
           return  "cards/add"

        case .deleteCard(let id):
            return "cards/delete/\(id)"

        case .updateCard(card: _):
            return "cards/update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .cards:
            return .post
        case .addCard(card: _):
            return .post
        case .updateCard(card: _):
            return .post
        case .deleteCard(id: _):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var params: [String: Any] {
        return [:]
    }

    var task: Task {
        switch self {
        case .cards:
            let request: fetchRequest = .init(
                base: .init(
                    location: .init(
                        longitude: LocationManager.shared.currentLocation?.coordinate.longitude ?? -1,
                        latitude: LocationManager.shared.currentLocation?.coordinate.latitude ?? -1),
                    deviceId: UIDevice.current.identifierForVendor!.uuidString
                )
            )
            return .requestJSONEncodable(request)

        case .addCard(let card):
            let request: addRequest = .init(
                card: card,
                base: .init(
                    location: .init(
                        longitude: LocationManager.shared.currentLocation?.coordinate.longitude ?? -1,
                        latitude: LocationManager.shared.currentLocation?.coordinate.latitude ?? -1),
                    deviceId: UIDevice.current.identifierForVendor!.uuidString
                )
            )
            let jsonData = try! JSONEncoder().encode(request)
            return .requestCompositeData(bodyData: jsonData, urlParameters: params)
           // return .requestJSONEncodable(request)

        case .deleteCard(let id):
            let request: deleteRequest = .init(
                id: id,
                base: .init(
                    location: .init(
                        longitude: LocationManager.shared.currentLocation?.coordinate.longitude ?? -1,
                        latitude: LocationManager.shared.currentLocation?.coordinate.latitude ?? -1),
                    deviceId: UIDevice.current.identifierForVendor!.uuidString
                )
            )
            let jsonData = try! JSONEncoder().encode(request)
            return .requestCompositeData(bodyData: jsonData, urlParameters: params)
            //return .requestJSONEncodable(request)

        case .updateCard(let card):
            let request: updateRequest = .init(
                card: card,
                base: .init(
                    location: .init(
                        longitude: LocationManager.shared.currentLocation?.coordinate.longitude ?? -1,
                        latitude: LocationManager.shared.currentLocation?.coordinate.latitude ?? -1),
                    deviceId: UIDevice.current.identifierForVendor!.uuidString
                )
            )
            let jsonData = try! JSONEncoder().encode(request)
            return .requestCompositeData(bodyData: jsonData, urlParameters: params)
          //  return .requestJSONEncodable(request, encoding: URLEncoding.queryString)
        }
    }
}
