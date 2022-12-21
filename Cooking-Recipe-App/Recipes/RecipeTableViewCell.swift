//
//  RecipeTableViewCell.swift
//  Cooking-Recipe-App
//
//  Created by Student on 14/12/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var tags: Tags!
    
    func configure(forRecipe recipe: Recipe) {
        
        titleLabel.text = recipe.title
        descriptionLabel.text = recipe.description
        
        if let image = UIImage(named: "zeppole") {
            recipeImageView.image = image
        }
        
        tags.withTags(recipe.categories)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
