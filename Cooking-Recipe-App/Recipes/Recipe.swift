//
//  Recipe.swift
//  Cooking-Recipe-App
//
//  Created by Student on 12/12/2022.
//

import Foundation
import UIKit.UIImage


struct Recipe : Codable, Identifiable {
    var id: UUID = UUID()
    var title : String
    var categories: [String]
    var source: String
    var yield: String
    var preparationTime: TimeInterval
    var cookingTime: TimeInterval
    var description: String?
    var image: Data?
    var ingredients: [Ingredient]
    var directions: [String]
    var isFavourite: Bool = false
}

struct Ingredient: Codable {
    var measurement: Measurement<Unit>?
    var text: String
}


extension Ingredient {
    // easier to use initializer
    init(_ measurementValue: Double, _ measurementUnit: Unit, _ text: String) {
        self.measurement = Measurement(value: measurementValue, unit: measurementUnit)
        self.text = text
    }
    
    // Create an instance of Ingredient by parsing text
    init?(fromLine line: String) {
        let ingredientRegex = try! NSRegularExpression(
            pattern: #"((?:\d+(?:\.\d+){0,1}){0,1}\s*[¼½¾⅓⅔]{0,1}){0,1}\s*(?:(tsp|tbsp|cups|cup|lb|oz|kg|g|ml|l)\s+){0,1}(.*)$"#,
            options: .caseInsensitive)
        guard let match = ingredientRegex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) else {return nil}
        
        let valueString = match.matchAt(1, forString: line)
        let unitString = match.matchAt(2, forString: line)
        let text = match.matchAt(3, forString: line)
        
        if valueString == nil || valueString!.isEmpty {
            self.measurement = nil
        } else {
            let unit = unitString == nil || unitString!.isEmpty ? Count.count : Ingredient.symbolToUnit(unitString!.lowercased())
            self.measurement = Measurement(value: Ingredient.parseFractionalNumber(valueString!), unit: unit!)
        }
        self.text = text ?? ""
    }
    
    
    // convert symbol string to Unit instance
    static func symbolToUnit(_ symbol: String) -> Unit? {
        switch symbol {
        case "tsp": return UnitVolume.teaspoons
        case "tbsp": return UnitVolume.tablespoons
        case "cups", "cup": return UnitVolume.cups
        case "lb": return UnitMass.pounds
        case "oz": return UnitVolume.fluidOunces // TODO: ounces can be mass ounces or fluid ounces
        case "kg": return UnitMass.kilograms
        case "g": return UnitMass.grams
        case "ml": return UnitVolume.milliliters
        case "l": return UnitVolume.liters
        default: return nil
        }
    }
    
    // parse a fractional number string into a double
    static func parseFractionalNumber(_ valueString: String) -> Double {
        let numberRegex = try! NSRegularExpression(pattern: #"(\d+(?:\.\d+){0,1}){0,1}\s*([¼½¾⅓⅔]){0,1}"#)
        let match = numberRegex.firstMatch(in: valueString, range: NSRange(valueString.startIndex..., in: valueString))
        let number1 = match?.matchAt(1, forString: valueString) ?? "0"
        var number2: Double
        switch match?.matchAt(2, forString: valueString) {
        case "¼": number2 = 1.0/4.0
        case "½": number2 = 1.0/2.0
        case "¾": number2 = 3.0/4.0
        case "⅓": number2 = 1.0/3.0
        case "⅔": number2 = 2.0/3.0
        default: number2 = 0.0
        }
        return try! Double(number1, format: .number) + number2
    }
    
}

// helper to get a matched group
extension NSTextCheckingResult {
    func matchAt(_ at: Int, forString: String) -> String? {
        let nsrange = self.range(at: at)
        guard nsrange != NSMakeRange(NSNotFound, 0) else { return nil }
        let range = Range(nsrange, in: forString)!
        return String(forString[range])
    }
}

// dimensionless unit for counting
class Count: Unit {
    class var count: Unit { return Count(symbol: "") }
}


// MARK: Recipe saving and loading
extension Recipe {
    static var archiveURL: URL {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsURL.appendPathComponent("recipes.plist")
        return documentsURL
    }
    
    static func saveRecipes(_ recipes: [Recipe]) {
        let plistEncoder = PropertyListEncoder()
        if let encodedRecipes = try? plistEncoder.encode(recipes) {
            try? encodedRecipes.write(to: archiveURL)
        }
    }
    
    static func loadRecipes() -> [Recipe]? {
        let plistDecoder = PropertyListDecoder()
        if let encodedRecipes = try? Data(contentsOf: archiveURL),
           let decodedRecipes = try? plistDecoder.decode([Recipe].self, from: encodedRecipes) {
            return decodedRecipes
        }
        return nil
    }
}


// MARK: Sample Recipes
extension Recipe {
    static let sample_recipes: [Recipe] = [
        Recipe(
            title: "Zeppole di San Giuseppe",
            categories: ["Italian", "Dessert"],
            source: "Christina Conte",
            yield: "12 pieces",
            preparationTime: TimeInterval(60*30),
            cookingTime: TimeInterval(60*35),
            description: "Traditional Italian Dessert",
            image: UIImage(named: "zeppole")!.pngData(),
            ingredients: [
                Ingredient(fromLine: "4 oz butter")!,
                Ingredient(fromLine: "1.5tsp sugar")!,
                Ingredient(fromLine: "8oz water")!,
                Ingredient(fromLine: "1 cups flour")!,
                Ingredient(fromLine: "4 eggs")!,
                Ingredient(fromLine: "2 egg yolks")!,
                Ingredient(fromLine: "200ml milk")!,
                Ingredient(fromLine: "1tsp vanilla extract")!,
            ],
            directions: [
                "Heat oven to 400ºF",
                """
                  First prepare the choux pastry, by placing the butter, sugar and water in a
                  medium sized saucepan over medium heat, until it comes to a rolling boil.
                """,
                "Add the flour, all at once and stir",
                "Remove from heat, add an egg, and beat well, then add the rest of eggs similarly",
                "place in piping bag or spoon onto a baking tray",
                "bake for about 30 minutes then leave for 10 minutes to cool",
                """
                    while the puffs are puffing, make the filling: place the yolks, sugar, starch, salt and vanilla
                    into a pot and whisk together, begin pouring warm milk then turn to low heat.
                """,
                "pipe the filling on top of the pastry to preference",
            ]
        ),
        Recipe(
            title: "Pancakes",
            categories: ["Breakfast"],
            source: "allrecipes.com",
            yield: "8 pankakes",
            preparationTime: TimeInterval(5*60),
            cookingTime: TimeInterval(10*60),
            image: UIImage(named: "pancake")!.pngData(),
            ingredients: [
                Ingredient(fromLine: "1.5 cups all purpose flour")!,
                Ingredient(fromLine: "3.5 tsp baking powder")!,
                Ingredient(fromLine: "1 tbsp white sugar")!,
                Ingredient(fromLine: "0.25tsp salt")!,
                Ingredient(fromLine: "1.25 cup milk")!,
                Ingredient(fromLine: "3 tbsp butter, melted")!,
                Ingredient(fromLine: "1 egg")!
            ],
            directions: [
                """
                    Sift flour, baking powder, sugar, and salt together in a large bowl.
                    Make a well in the center and add milk, melted butter, and egg; mix until smooth.
                """,
                """
                    Heat a lightly oiled griddle or pan over medium-high heat. Pour or scoop the batter
                    onto the griddle, using approximately 1/4 cup for each pancake; cook until bubbles form
                    and the edges are dry, about 2 to 3 minutes. Flip and cook until browned on the other side.
                    Repeat with remaining batter.
                """,
            ]
        ),
        Recipe(
            title: "Beef and Broccoli",
            categories: ["Asian", "Lunch", "Dinner"],
            source: "based.cooking",
            yield: "3 servings",
            preparationTime: TimeInterval(15*60),
            cookingTime: TimeInterval(20*60),
            image: UIImage(named: "beef-broccoli")!.pngData(),
            ingredients: [
                Ingredient(fromLine: "0.5 lb Beef, cut into strips")!,
                Ingredient(fromLine: "2 tbsp Vegetable oil")!,
                Ingredient(fromLine: "1tbsp Ginger, minced")!,
                Ingredient(fromLine: "2 Garlic cloves, minced")!,
                Ingredient(fromLine: "1 cups Carrots, sliced")!,
                Ingredient(fromLine: "Snow peas")!,
                Ingredient(fromLine: "Bean sprouts")!,
                Ingredient(fromLine: "1 cups roccoli pieces")!,
                Ingredient(fromLine: "1 cup Beef bouillon")!,
                Ingredient(fromLine: "1 tbsp corn starch")!,
                Ingredient(fromLine: "1 tbsp soy sauce")!,
            ],
            directions: [
                "Heat oil, add beef and stir-fry until meat is browned and push to sides of pan.",
                "Add broccoli and carrots. Cover and steam vegetables until they are only slightly crunchy.",
                "Remove vegetables to a bowl. Add bouillon, salt and pepper to meat.",
                "Combine corn starch, 2 Tbsp water, and soy sauce. Add to meat to thicken sauce.",
                "Add vegetables and heat. Serve over rice.",
            ]
        ),
        Recipe(
            title: "Tabouleh",
            categories: ["Mediterranean", "Salad"],
            source: "based.cooking",
            yield: "12",
            preparationTime: TimeInterval(15*60),
            cookingTime: TimeInterval(30*60),
            description: "Traditional Mediterranean Salad",
            image: UIImage(named: "tabouleh")!.pngData(),
            ingredients: [
                Ingredient(fromLine:"2 cups Cracked Wheat (bulghur)")!,
                Ingredient(fromLine:"2 cups Very Hot Water (or as directed)")!,
                Ingredient(fromLine:"1 Cucumber, chopped")!,
                Ingredient(fromLine:"2 small Tomatoes, chopped")!,
                Ingredient(fromLine:"1 bunch Green Onions, sliced")!,
                Ingredient(fromLine:"½ cup Mint (fresh), chopped")!,
                Ingredient(fromLine:"2 cup Parsley (fresh), chopped")!,
                Ingredient(fromLine:"1 clove Garlic, minced")!,
                Ingredient(fromLine:"½ cup Lemon Juice (fresh)")!,
                Ingredient(fromLine:"¾ cup Olive Oil")!,
                Ingredient(fromLine:"1 Tbsp Pepper")!,
                Ingredient(fromLine:"2 tsp Salt")!,
            ],
            directions: [
                "Soak the cracked wheat in the hot water until the water is absorbed, about 30 minutes.",
                "Drain any excess water, if necessary, and squeeze dry.",
                "Combine the salad ingredients (all but the oil, lemon juice, salt and pepper dressing ingredients) in a medium bowl.",
                "Mix the dressing ingredients together and stir into the salad mix",
                "Serve chilled or at room temperature.",
            ]
        ),
        Recipe(
            title: "Tomato and Grilled Bell Pepper Soup",
            categories: ["Soup", "Hot Starters"],
            source: "based.cooking",
            yield: "12",
            preparationTime: TimeInterval(10*60),
            cookingTime: TimeInterval(30*60),
            image: UIImage(named: "tomato-soup")!.pngData(),
            ingredients: [
                Ingredient(fromLine: "10 tomatoes")!,
                Ingredient(fromLine: "2 red bell peppers")!,
                Ingredient(fromLine: "2 onions")!,
                Ingredient(fromLine: "1 clove of garlic")!,
                Ingredient(fromLine: "1L stock or broth")!,
                Ingredient(fromLine: "¾ tsp Cayenne pepper")!,
                Ingredient(fromLine: "1tsp paprika powder")!,
                Ingredient(fromLine: "3tsp bruschetta herbs")!,
                Ingredient(fromLine: "1tsp oregano")!,
                Ingredient(fromLine: "1tsp giner syrup")!,
                Ingredient(fromLine: "2Tbsp olive oil")!,
                Ingredient(fromLine: "2Tbsp heavy cream")!,
            ],
            directions: [
                "Halve, deseed and grill the bell peppers in an oven or on a grill. Remove skin after grilling.",
                "Skin and quarter tomatoes.",
                "Sauté onion and crushed garlic in a large soup pan with olive oil.",
                "Add broth/stock, tomatoes, bell paper and purée with a stick blender.",
                "Add spices, syrup and cream.",
            ]
        ),
    ]
}
