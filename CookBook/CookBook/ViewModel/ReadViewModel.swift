//
//  ReadViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/27.
//

import Foundation
import Firebase

class ReadViewModel {

    var recipe: Recipe?

    func updateLikes(with documentId: String, completion: @escaping (Result<String, Error>) -> Void) {

        DataManager.shared.updateLikes(documentId: documentId) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): Likes increase 1")

                completion(.success(documentId))

            case .failure(let error):

                print(error)

                completion(.failure(error))
            }
            
        }
    }

    func updatefavoritesUserId(with documentId: String, favoritesUserId: String, completion: @escaping (Result<String, Error>) -> Void) {

        DataManager.shared.updatefavoritesUserId(documentId: documentId, favoritesUserId: favoritesUserId) { [weak self] result in

            switch result {

            case .success(let documentId):

                print("\(documentId): \(favoritesUserId) added")

                completion(.success(documentId))

            case .failure(let error):

                print(error)

                completion(.failure(error))
            }

        }
    }
}
