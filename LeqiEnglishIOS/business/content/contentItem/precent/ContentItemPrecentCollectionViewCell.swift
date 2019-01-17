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
    
    @IBOutlet weak var precentRootView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var precentLabel: UILabel!
    let percent = PercentView()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         percent.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
         self.precentRootView.addSubview(percent)
    }
    
    func setItem(item:ReciteContentVO){
        titleLabel.text = item.title
        precentLabel.text = "\(item.finishedPercent ?? 0)%"
        percent.perscent = CGFloat(item.finishedPercent ?? 0)/100
       
        
        
        if let imagePath = item.imagePath{
            Service.download(path: "file/download?path=\(imagePath)", filePath: imagePath){(imagePath) in
                if(imagePath.isEmpty){
                     self.imageView.image = UIImage(named: "default_img")
                }else{
                   self.imageView.image = UIImage(contentsOfFile: imagePath)
                }
                
            }
        }else{
            self.imageView.image = UIImage(named: "default_img")
        }
    }

}
