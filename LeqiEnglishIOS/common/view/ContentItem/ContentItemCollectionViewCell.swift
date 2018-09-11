//
//  ContentItemCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
let CONTENT_ITEM_CELL = "CONTENT_ITEM_CELL"
class ContentItemCollectionViewCell: UICollectionViewCell {
    


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setItem(item:Content){
        titleLabel.text = item.title
    }

}
