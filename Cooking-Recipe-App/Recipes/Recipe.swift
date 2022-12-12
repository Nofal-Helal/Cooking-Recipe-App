//
//  Recipe.swift
//  Cooking-Recipe-App
//
//  Created by Student on 12/12/2022.
//

import Foundation


struct Recipe : Codable {
    var title : String
    var categories: [String]
    var source: String
    var yield: String
    var preparationTime: TimeInterval
    var cookingTime: TimeInterval
    var description: String?
    var image: String?
    var ingredients: [Ingredient]
    var directions: [String]
}

struct Ingredient: Codable {
    var measurement: Measurement<Unit>
    var text: String
}
