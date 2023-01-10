//
//  Category.swift
//  Cooking-Recipe-App
//
//  Created by Student on 08/01/2023.
//

import Foundation
import UIKit

struct Category : Codable {
    let title : String
    let imageData : Data?


    static var sampleCategories: [Category] = [
        Category(title: "Asian", imageData: UIImage(named: "img_asian")?.jpegData(compressionQuality: 0.9)),
        Category(title: "Breakfast",imageData: UIImage(named: "img_breakfast")!.jpegData(compressionQuality: 0.9)),
        Category(title: "Dessert", imageData: UIImage(named:"img_dessert")!.jpegData(compressionQuality: 0.9)),
        Category(title: "Dinner", imageData: UIImage(named:"img_dinner")!.jpegData(compressionQuality: 0.9)),
        Category(title: "Hot Starters", imageData: UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.9)),
        Category(title: "Italian", imageData: UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.9)),
        Category(title: "Lunch", imageData: UIImage(named:"img_lunch")!.jpegData(compressionQuality: 0.9)),
        Category(title: "Mediterranean", imageData: UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.9)),
        Category(title: "Salad", imageData: UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.9)),
        Category(title: "Soup", imageData: UIImage(named: "img_soup")?.jpegData(compressionQuality: 0.9)),
    ]
    
    static var archiveURL: URL {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsURL.appendPathComponent("categories.plist")
        return documentsURL
    }
    
    static func saveCategories(_ categories: [Category]) {
        let plistEncoder = PropertyListEncoder()
        if let encodedCategories = try? plistEncoder.encode(categories) {
            try? encodedCategories.write(to: archiveURL)
        }
    }
    
    static func loadCategories() -> [Category]? {
        let plistDecoder = PropertyListDecoder()
        if let encodedCategories = try? Data(contentsOf: archiveURL),
           let decodedCategories = try? plistDecoder.decode([Category].self, from: encodedCategories) {
            return decodedCategories
        }
        return nil
    }
}
