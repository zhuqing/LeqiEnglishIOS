//
//  CircleView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/17.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var bgColor:UIColor = UIColor.white

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        bgColor.set()
        let circle =   UIBezierPath(ovalIn: rect)
        circle.lineWidth = 1;
        circle.fill();
    }

}
