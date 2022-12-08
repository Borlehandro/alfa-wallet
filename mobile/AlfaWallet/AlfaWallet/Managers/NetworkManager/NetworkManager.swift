//
//  NetworkManager.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 07.12.2022.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }

    func fetchCardsList(completion: @escaping (Result<Response<Card>, Error>) -> Void)
    func addCard(card: Card, completion: @escaping (Result<Response<Card>, Error>) -> Void)
    func deleteCard(cardID: Int, completion: @escaping (Result<Response<Card>, Error>) -> Void)
}

class NetworkManager: Networkable {
    func addCard(card: Card, completion: @escaping (Result<Response<Card>, Error>) -> Void) {
        request(target: .addCard(card: card), completion: completion)
    }

    func deleteCard(cardID: Int, completion: @escaping (Result<Response<Card>, Error>) -> Void) {
        request(target: .deleteCard(id: cardID), completion: completion)
    }
    
    func fetchCardsList(completion: @escaping (Result<Response<Card>, Error>) -> Void) {
        request(target: .cards, completion: completion)
    }

    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
}

// MARK: - Extensions

private extension NetworkManager {
    func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
