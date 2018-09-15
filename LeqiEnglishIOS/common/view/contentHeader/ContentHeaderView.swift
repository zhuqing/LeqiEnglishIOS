//
//  ContentHeaderView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol ContentHeaderViewDelegate {
    func clickMoreButton()
}

class ContentHeaderView: UIView {
    
    private var name:String

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

     init(frame: CGRect,name:String) {
        self.name = name;
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentHeaderView{
    
    private func setupUI(){
     addTitleLabel()
        addMoreLabel()
    }
    
    private func addTitleLabel(){
        let titleLabel = UILabel();
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = name
        
        titleLabel.textColor = UIColor.darkText
       
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.frame = CGRect(x: 3, y: 0, width: 80, height: CONTENT_HEADER_HEIGHT)
        addSubview(titleLabel)
        
    }
    
    private func addMoreLabel(){
        let moreLabel = UIButton();
        moreLabel.setTitle("更多>", for: .normal)
        moreLabel.setTitleColor(UIColor.darkGray, for: .normal)

        moreLabel.tintColor = UIColor.blue
        
        moreLabel.titleLabel?.textColor = UIColor.darkGray
        moreLabel.titleLabel?.textAlignment = .center
        moreLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
      
        moreLabel.frame = CGRect(x: SCREEN_WIDTH-60, y: 0, width: 50, height: CONTENT_HEADER_HEIGHT)
        addSubview(moreLabel)
        
    }
}
