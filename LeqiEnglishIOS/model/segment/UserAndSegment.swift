//
//  UserAndSegment.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class UserAndSegment : Entity{
    
    
    var userId:String?
    
    var segmentId:String?
    
    var contentId:String?
    
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
        case "segmentId":
            self.segmentId = value as? String
        case "contentId":
            self.contentId = value as? String
            
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
        if  let v = self.segmentId{
            dic["segmentId"] = v as NSObject
        }
        if  let v = self.contentId{
            dic["contentId"] = v as NSObject
        }
        
        return dic
    }
}
