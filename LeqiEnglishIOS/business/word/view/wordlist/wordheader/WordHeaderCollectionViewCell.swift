//
//  WordHeaderCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordHeaderCollectionViewCell: UICollectionViewCell {

    static let WORD_HEADER_INDENTIFY = "WORD_HEADER_INDENTIFY"
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setHeader(_ header:String){
        self.headerLabel.text = header
    }

}
