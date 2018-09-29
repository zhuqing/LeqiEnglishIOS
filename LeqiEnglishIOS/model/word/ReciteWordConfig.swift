//
//  ReciteWordConfig.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/27.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class ReciteWordConfig : Entity{
    
    
    var userId:String?
    
    var reciteNumberPerDay:Int?
    
    var hasReciteNumber:Int?
    
    var myWordsNumber:Int?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "userId":
            self.userId = value as? String
        case "reciteNumberPerDay":
            self.reciteNumberPerDay = value as? Int
        case "hasReciteNumber":
            self.hasReciteNumber = value as? Int
        case "myWordsNumber":
            self.myWordsNumber = value as? Int
            
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
        if  let v = self.reciteNumberPerDay{
            dic["reciteNumberPerDay"] = v as NSObject
        }
        if  let v = self.hasReciteNumber{
            dic["hasReciteNumber"] = v as NSObject
        }
        if  let v = self.myWordsNumber{
            dic["myWordsNumber"] = v as NSObject
        }
        
        return dic
    }
}
