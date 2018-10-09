//
//  NavigationCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class NavigationCollectionViewCell: UICollectionViewCell {
 static let NAVIGAAION_CELL_INDENTIFY = "NAVIGAAION_CELL_INDENTIFY"
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(_ text:String){
        titleLabel.text = text
    }

}
