//
//  WordScentenseCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordScentenseCollectionViewCell: UICollectionViewCell {
    static let WORD_SCENTENSE_COLLECTION_VIEWCELL = "WORD_SCENTENSE_COLLECTION_VIEWCELL"
    
    var wordAndSegment:WordAndSegment?{
        didSet{
            clear()
            if let ws = self.wordAndSegment{
                setItem(item: ws)
            } 
        }
    }
    
    @IBOutlet weak var enLabel: UILabel!
    @IBOutlet weak var chLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    private func setItem(item:WordAndSegment){
        let ch_em = StringUtil.toChAndEN(str: item.scentence!)
        enLabel.text = ch_em.0
        chLabel.text = ch_em.1
        
      
    }
    
    private func clear(){
        enLabel.text = ""
        chLabel.text = ""
    }

}
