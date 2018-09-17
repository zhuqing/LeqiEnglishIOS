//
//  ContentItemPrecentCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import Kingfisher

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
        precentLabel.text = "\(item.finishedPercent ?? 0)%"
        
        if let imagePath = item.imagePath{
            Service.download(path: "file/download?path=\(imagePath)", filePath: imagePath){(imagePath) in
                self.imageView.image = UIImage(contentsOfFile: imagePath)
            }
        }else{
            self.imageView.image = UIImage(named: "obma")
        }
    }

}
