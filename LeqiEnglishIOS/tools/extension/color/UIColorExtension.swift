//
//  UIColorExtension.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(r:CGFloat,b:CGFloat,y:CGFloat){
        self.init(red: r/255.0, green: b/255.0, blue: y/255.0, alpha: 1)
    }

}
