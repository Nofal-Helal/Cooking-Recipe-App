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
        
        if let image = recipe.image {
            recipeImageView.image = UIImage(data: image)
        }
        
        var p = [NSAttributedString]()
        p.append(Tags.timeTag(recipe.preparationTime + recipe.cookingTime))
        p.append(contentsOf: recipe.categories.map(Tags.normalTag(_:)))
        p.append(Tags.sourceTag(recipe.source))
        tags.withTags(p)
        
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
