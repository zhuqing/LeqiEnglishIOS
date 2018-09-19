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
        self.contentView.buttomBorder(width: CGFloat(2), borderColor: UIColor.black)
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
        bar.frame = CGRect(x: 0, y: self.frame.height - PlaySegmentBar.HEIGHT, width: SCREEN_WIDTH, height: PlaySegmentBar.HEIGHT)
        self.contentView.addSubview(bar)
    }
    
    func stop(bar:UIView){
        bar.removeFromSuperview()

    }
    
 

}
