//
//  Suggestion.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class Suggestion : Entity{
    
    
    var userId:String?
    
    var message:String?
    
    var contact:String?
    
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
        case "message":
            self.message = value as? String
        case "contact":
            self.contact = value as? String
            
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
        if  let v = self.message{
            dic["message"] = v as NSObject
        }
        if  let v = self.contact{
            dic["contact"] = v as NSObject
        }
        
        return dic
    }
}
