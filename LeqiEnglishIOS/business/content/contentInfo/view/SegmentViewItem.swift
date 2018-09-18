//
//  SegmentViewItem.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/17.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class SegmentViewItem: UICollectionViewCell {
    
    static let SEGMENT_VIEW_ITEM_CELL = "SEGMENT_VIEW_ITEM_CELL"
    
    var segment:Segment?{
        didSet{
            updateTitle()
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var title: UILabel!
    
    var content:Content?{
        didSet{
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
}

extension SegmentViewItem{
    //更新界面的值
    private func updateTitle(){
        guard let segment = self.segment else{
            self.title.text = ""
            return
        }
        
        guard let title = segment.title else{
              self.title.text = ""
            return
        }
        self.title.text = title
    }
    
    private func updateImageView(){
        
    }
}

