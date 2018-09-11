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
        
    }
}
