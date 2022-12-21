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


extension Recipe {
    static let sample_recipes: [Recipe] = [
        Recipe(
            title: "Zeppole di San Giuseppe",
            categories: ["Italian", "Dessert"],
            source: "Cristene",
            yield: "12 pieces",
            preparationTime: TimeInterval(60*30),
            cookingTime: TimeInterval(60*35),
            description: "Traditional Italian Dessert",
            ingredients: [
                Ingredient(measurement: Measurement(value: 4, unit: UnitVolume.fluidOunces), text: "butter"),
                Ingredient(measurement: Measurement(value: 1.5, unit: UnitVolume.teaspoons), text: "sugar"),
                Ingredient(measurement: Measurement(value: 1.5, unit: UnitVolume.teaspoons), text: "flour"),
            ],
            directions: [
                "Heat oven to 400ºF",
                "First prepare the choux pastry",
                "Remove from heat",
            ]
        ),
        Recipe(
            title: "Pancakes",
            categories: ["Breakfast"],
            source: "allrecipes.com",
            yield: "1 piece",
            preparationTime: TimeInterval(5*60),
            cookingTime: TimeInterval(10*60),
            ingredients: [
            Ingredient(measurement: Measurement(value: 1.5, unit: UnitVolume.cups), text: "all purpose flour"),
            Ingredient(measurement: Measurement(value: 3.5, unit: UnitVolume.teaspoons), text: "baking powder"),
            Ingredient(measurement: Measurement(value: 1, unit: UnitVolume.tablespoons), text: "white sugar"),
            Ingredient(measurement: Measurement(value: 0.25, unit: UnitVolume.teaspoons), text: "salt"),
            Ingredient(measurement: Measurement(value: 1.25, unit: UnitVolume.cups), text: "milk"),
            Ingredient(measurement: Measurement(value: 3, unit: UnitVolume.tablespoons), text: "butter, melted"),
            Ingredient(measurement: Measurement(value: 1, unit: Unit(symbol: "")), text: "egg")
            ],
            directions: [""]
        )
    ]
}
