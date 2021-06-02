//
//  FeedViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/16.
//
// swiftlint:disable implicit_getter

import UIKit

class FeedViewModel {

    var feed: Feed

    init(model feed: Feed) {
        
        self.feed = feed
    }

    var challenger: String {

        get {
            return feed.challenger
        }
    }

    var createdTime: String {

        get {
            return Date.dateFormatter.string(from: Date.init(milliseconds: feed.createdTime))
        }
    }

    var id: String {

        get {
            return feed.id!
        }
    }

    var isChallenged: Bool {

        get {
            return feed.isChallenged
        }
    }

    var mainImage: String {

        get {
            return feed.mainImage
        }
    }

    var name: String {

        get {
            return feed.name
        }
    }

    var ownerId: String {

        get {
            return feed.ownerId
        }
    }

    var portrait: String {

        get {
            return feed.portrait
        }
    }

    var recipeId: String {

        get {
            return feed.recipeId
        }
    }

    var recipeName: String {
        
        get {
            return feed.recipeName
        }
    }
}
