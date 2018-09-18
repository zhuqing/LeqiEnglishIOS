//
//  PlaySementItemCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class PlaySementItemCollectionViewCell: UICollectionViewCell {
    
    static let PALY_SEGMENT_ITEM_CELL = "PALY_SEGMENT_ITEM_CELL"
    
    var segmentPlayItem:SegmentPlayItem?

    @IBOutlet weak var chineseTextLabel: UILabel!
    @IBOutlet weak var englishTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setItem(item:SegmentPlayItem){
        self.segmentPlayItem = item
        
        if let text = item.englishSenc{
            englishTextLabel.text = text
        }
        
        if let text = item.chineseSenc{
            chineseTextLabel.text = text
        }
        
    }
    
    func play(bar:UIView){
        
    }
    
    func stop(bar:UIView){
        
    }

}
