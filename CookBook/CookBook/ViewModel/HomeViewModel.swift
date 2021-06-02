//
//  HomeViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation

class HomeViewModel {

    // [FeedViewModel] 初始化
    let feedViewModels = Box([FeedViewModel]())

    // var recipe: Recipe?

    func fetchFeedsData() {

        DataManager.shared.fetchFeeds { [weak self] result in

            switch result {

            case .success(let feeds):

                print("Fetch feeds success!")

                self?.setFeeds(feeds)

            case .failure(let error):

                print("\(error)")
            }
        }
    }

//    func fetchRecipe(reciepeId: String, completion: @escaping (Result<Recipe, Error>) -> Void) {
//
//        DataManager.shared.fetchRecipe(documentId: reciepeId) { [weak self] result in
//
//            switch result {
//
//            case .success(let recipe):
//
//                print("Fetch recipe success!")
//
//                completion(.success(recipe))
//
//            case .failure(let error):
//
//                print("fetchData.failure: \(error)")
//
//                completion(.failure(error))
//            }
//        }
//    }

    func convertFeedsToViewModels(from feeds: [Feed]) -> [FeedViewModel] {

        var viewModels: [FeedViewModel] = []

        for feed in feeds {

            let viewModel = FeedViewModel(model: feed)

            viewModels.append(viewModel)
        }

        return viewModels
    }

    func setFeeds(_ feeds: [Feed]) {

        // 傳轉換好的值 (viewModels) 給 VM.value，使 listener 帶值給所有綁定 的 View 顯示資料
        feedViewModels.value = convertFeedsToViewModels(from: feeds)
    }
}
