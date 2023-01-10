//
//  AppDelegate.swift
//  Cooking-Recipe-App
//
//  Created by Student on 05/12/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let userDefaults = UserDefaults.standard
        
        // Save sample recipes on first launch
        if userDefaults.bool(forKey: "First Launch") == false {
            if Recipe.loadRecipes() == nil {
                Recipe.saveRecipes(Recipe.sample_recipes)
            }
            if Category.loadCategories() == nil {
                Category.saveCategories(Category.sampleCategories)
            }
        }
        userDefaults.set(true, forKey: "First Launch")
        
        // set theme
        SettingsViewController.setDisplayTheme(DisplayTheme(rawValue: userDefaults.integer(forKey: "Display Theme")) ?? .System)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

