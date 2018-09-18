//
//  PlaySegmentBar.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class PlaySegmentBar: UIView {

    var mp3Path:String

    init(frame: CGRect,mp3Path:String) {
        self.mp3Path = mp3Path
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension PlaySegmentBar{
    private func setupUI(){
        
    }
}
