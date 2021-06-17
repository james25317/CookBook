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
    
    init(model recipe: Recipe) {
        self.recipe = recipe
    }
    
    var id: String {
        return recipe.id ?? ""
    }
    
    var createdTime: Timestamp {
        return recipe.createdTime
    }
    
    var description: String {
        return recipe.description
    }
    
    var favoritesUserId: [String] {
        return recipe.favoritesUserId
    }
    
    var ingredients: [Ingredient] {
        return recipe.ingredients
    }
    
    var isEditDone: Bool {
        return recipe.isEditDone
    }
    
    var likedUserId: [String] {
        return recipe.likedUserId
    }
    
    var likes: Int64 {
        return recipe.likes
    }
    
    var mainImage: String {
        return recipe.mainImage
    }
    
    var name: String {
        return recipe.name
    }
    
    var ownerId: String {
        return recipe.ownerId
    }
    
    var steps: [Step] {
        return recipe.steps
    }

    var challenger: String {
        return recipe.challenger
    }
}
