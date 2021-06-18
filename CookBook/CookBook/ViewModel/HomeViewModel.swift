//
//  HomeViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import Foundation

class HomeViewModel {

    let feedViewModels = Box([FeedViewModel]())

    var scrollToTop: (() -> Void)?

    func onScrollToTop() {

        self.scrollToTop?()
    }

    func fetchFeedsData() {

        FeedManager.shared.fetchFeeds { [weak self] result in

            switch result {
            case .success(let feeds):

                self?.setFeeds(feeds)
                print("Fetch feeds success!")

            case .failure(let error):

                print("\(error)")
            }
        }
    }

    func convertFeedsToViewModels(from feeds: [Feed]) -> [FeedViewModel] {

        var viewModels: [FeedViewModel] = []

        for feed in feeds {
            let viewModel = FeedViewModel(model: feed)
            viewModels.append(viewModel)
        }

        return viewModels
    }

    func setFeeds(_ feeds: [Feed]) {

        feedViewModels.value = convertFeedsToViewModels(from: feeds)
    }

    func filteredBlockListFromFeeds() -> [FeedViewModel] {

        return feedViewModels.value.filter { viewModel in
            
            return !UserManager.shared.user.blockList.contains(viewModel.recipeId) &&
                !UserManager.shared.user.blockList.contains(viewModel.challengerRecipeId)
        }
    }
}
