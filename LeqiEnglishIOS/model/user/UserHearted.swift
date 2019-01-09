//
//  UserHearted.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/7.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import Foundation

class UserHearted : Entity{
    
    
    var userId:String?
    
    var targetId:String?
    
    var type:Int?
    
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
        case "targetId":
            self.targetId = value as? String
        case "type":
            self.type = value as? Int
            
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
        if  let v = self.targetId{
            dic["targetId"] = v as NSObject
        }
        if  let v = self.type{
            dic["type"] = v as NSObject
        }
        
        return dic
    }
}
