//
//  UserBoardView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol UserBoardViewDelegate {
    func reciteWordButtonClick()
}

class UserBoardView: UICollectionViewCell {
   static let USER_BOARDER_VIEW_REUSE_IDENTIFIRE = "USER_BOARDER_VIEW_REUSE_IDENTIFIRE"
   
    @IBOutlet weak var hasRecite: UILabel!
    @IBOutlet weak var reciteWordButton: UIButton!
    
    @IBOutlet weak var hasLoginDaysLabel: UILabel!
    @IBOutlet weak var userHeaderImage: UIImageView!
    
    var delegate:UserBoardViewDelegate?
    
    var user:User?{
        didSet{
            
        }
    }
   
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }

    
}

extension UserBoardView{
    private func setUpUI(){
        initListener()
    }
    
    private func initListener(){
        reciteWordButton.addTarget(self, action: #selector(UserBoardView.reciteWordButtonClick), for: .touchDown)
    }
    
    @objc private func reciteWordButtonClick(){
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.reciteWordButtonClick()
    }
}
