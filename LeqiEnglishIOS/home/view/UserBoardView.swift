//
//  UserBoardView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserBoardView: UICollectionViewCell {
   static let USER_BOARDER_VIEW_REUSE_IDENTIFIRE = "USER_BOARDER_VIEW_REUSE_IDENTIFIRE"
    var user:User?{
        didSet{
            
        }
    }
   
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
