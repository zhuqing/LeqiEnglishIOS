//
//  ContentItemCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import Kingfisher

let CONTENT_ITEM_CELL = "CONTENT_ITEM_CELL"
class ContentItemCollectionViewCell: UICollectionViewCell {
    


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setItem(item:Content){
        titleLabel.text = item.title
        
        if let imagePath = item.imagePath{
            Service.download(path: "file/download?path=\(imagePath)", filePath: imagePath){(imagePath) in
                self.imageView.image = UIImage(contentsOfFile: imagePath)
            }
        }else{
             self.imageView.image = UIImage(named: "obma")
        }
    }

}