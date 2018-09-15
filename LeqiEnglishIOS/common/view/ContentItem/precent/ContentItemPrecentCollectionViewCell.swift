//
//  ContentItemPrecentCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

let CONTENT_ITEM_ORECENT_CELL = "CONTENT_ITEM_ORECENT_CELL"
class ContentItemPrecentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var precentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setItem(item:ReciteContentVO){
        titleLabel.text = item.title
        precentLabel.text = "\(item.finishedPercent!)%"
    }

}
