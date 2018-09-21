//
//  StringUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class StringUtil: NSObject {
    //排除空字符串
    class func exceptEmpty(_ str:String?)->String?{
        if let s = str {
            if(s.count == 0){
                return nil
            }
            return str
        }
        
        return nil
    }
}
