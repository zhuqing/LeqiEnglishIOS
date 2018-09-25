//
//  DictionaryUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class DictionaryUtil: NSObject {
    //把对象生产的字典转换成，字符串类型的字典
    class func toStringString(data:[String:NSObject])->[String:String]{
        var dataStr = [String:String]()
        
        for (key , value) in data {
            dataStr[key] = "\(value)"
        }
        
        return dataStr
    }
}
