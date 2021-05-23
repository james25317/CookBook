//
//  RecipeViewModel.swift
//  CookBook
//
//  Created by James Hung on 2021/5/20.
//

import Foundation
import Firebase

class RecipeViewModel {
    
    var recipe: Recipe
    
    var onFetch: (() -> Void)?
    
    init(model recipe: Recipe) {

        self.recipe = recipe
    }
    
    var createdTime: Timestamp {
        get {
            return recipe.createdTime
        }
    }
    
    var description: String {
        get {
            return recipe.description
        }
    }
    
    var favoritesUserId: [String] {
        get {
            return recipe.favoritesUserId
        }
    }
    
    var ingredients: [Ingredient] {
        get {
            return recipe.ingredients
        }
    }
    
    var isEditDone: Bool {
        get {
            return recipe.isEditDone
        }
    }
    
    var likedUserId: [String] {
        get {
            return recipe.likedUserId
        }
    }
    
    var likes: Int {
        get {
            return recipe.likes
        }
    }
    
    var mainImage: String {
        get {
            return recipe.mainImage
        }
    }
    
    var name: String {
        get {
            return recipe.name
        }
    }
    
    var owner: String {
        get {
            return recipe.owner
        }
    }
    
    var steps: [Step] {
        get {
            return recipe.steps
        }
    }
}