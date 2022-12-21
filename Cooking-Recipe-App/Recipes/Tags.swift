//
//  Tags.swift
//  Cooking-Recipe-App
//
//  Created by Student on 21/12/2022.
//

import UIKit

class Tags: UIView {

    func withTags(_ data:[String]) {
        for v in subviews {
            v.removeFromSuperview()
        }
        var xPos:CGFloat = 0
        var ypos: CGFloat = 0
        var tag: Int = 1
        for str in data  {
            let startstring = str as NSString
            let font = UIFont(name: "Helvetica Neue", size: 13)
            let attributes = [NSAttributedString.Key.font: font]
            let width = startstring.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
            if (xPos + width + CGFloat(17.0)) > self.frame.width  - 30.0 {
                //we are exceeding size need to change xpos
                xPos = 0
                ypos = ypos + 20.0 + 8.0
            }
            
            let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width:width + 17.0 , height: 20.0))
            bgView.layer.cornerRadius = 10.0
            bgView.backgroundColor = UIColor.secondarySystemBackground
            bgView.tag = tag
            self.addSubview(bgView)
            
            let textlable = UILabel(frame: CGRect(x: 17.0/2, y: 0.0, width: width, height: bgView.frame.size.height))
            textlable.font = UIFont(name: "Helvetica Neue", size: 13.0)
            textlable.text = (startstring as String)
            textlable.textColor = UIColor.label
            bgView.addSubview(textlable)
            
//            let button = UIButton(type: .custom)
//            button.frame = CGRect(x: bgView.frame.size.width - 2.5 - 23.0, y: 3.0, width: 23.0, height: 23.0)
//            button.backgroundColor = UIColor.white
//            button.layer.cornerRadius = CGFloat(button.frame.size.width)/CGFloat(2.0)
//            button.setImage(UIImage(named: "CrossWithoutCircle"), for: .normal)
//            button.tag = tag
//            bgView.addSubview(button)
//            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(17.0) + CGFloat(43.0)
//            self.addSubview(bgView)
            
        
            xPos = xPos + width + CGFloat(17.0) + CGFloat(8.5)
            tag = tag  + 1
          }
          
       }
    
    
}
