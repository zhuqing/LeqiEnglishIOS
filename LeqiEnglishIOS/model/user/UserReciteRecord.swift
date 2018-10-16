//
//  UserReciteRecord.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/16.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class UserReciteRecord : Entity{
    
    
    var userId:String?
    
    var learnTime:Int64?
    
    var learnDay:Int64?
    
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
        case "learnTime":
            self.learnTime = value as? Int64
        case "learnDay":
            self.learnDay = value as? Int64
            
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
        if  let v = self.learnTime{
            dic["learnTime"] = v as NSObject
        }
        if  let v = self.learnDay{
            dic["learnDay"] = v as NSObject
        }
        
        return dic
    }
}
