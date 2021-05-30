//
//  todayRecipeViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/30.
//

import Foundation

class TodayRecipeViewModel {

    var video: TodayRecipe

    init(model video: TodayRecipe) {

        self.video = video
    }

    var id: String {
        get {
            return video.id ?? ""
        }
    }

    var videoId: String {
        get {
            return video.videoId
        }
    }
}
