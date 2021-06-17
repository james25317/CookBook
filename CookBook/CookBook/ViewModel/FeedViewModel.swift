//
//  FeedViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//

import UIKit

class FeedViewModel {

    var feed: Feed

    init(model feed: Feed) {

        self.feed = feed
    }

    var challenger: String {
        return feed.challenger
    }

    var challengerRecipeId: String {
        return feed.challengerRecipeId
    }

    var challengerRecipeName: String {
        return feed.challengerRecipeName
    }

    var challengerRecipeMainImage: String {
        return feed.challengerRecipeMainImage
    }

    var createdTime: String {
        return Date.dateFormatter.string(from: Date.init(milliseconds: feed.createdTime))
    }

    var id: String {
        return feed.id ?? ""
    }

    var isChallenged: Bool {
        return feed.isChallenged
    }

    var mainImage: String {
        return feed.mainImage
    }

    var name: String {
        return feed.name
    }

    var ownerId: String {
        return feed.ownerId
    }

    var portrait: String {
        return feed.portrait
    }

    var recipeId: String {
        return feed.recipeId
    }

    var recipeName: String {
        return feed.recipeName
    }
}
