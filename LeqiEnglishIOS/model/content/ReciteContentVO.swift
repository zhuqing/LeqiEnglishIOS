//
//  RecitedContentVO.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/6.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import Foundation

class ReciteContentVO : Content{
    
    
   // var userId:String?
    
    var finishedPercent:Int?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
       // case "userId":
         //   self.userId = value as? String
        case "finishedPercent":
            self.finishedPercent = value as? Int
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.userId{
            dic["userId"] = v as NSObject
        }
        if  let v = self.finishedPercent{
            dic["finishedPercent"] = v as NSObject
        }
        
        return dic
    }
}
