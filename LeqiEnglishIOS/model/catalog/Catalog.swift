//
//  Catalog.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/6.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class Catalog : Entity{
    
    
    var title:String?
    
    var imagePath:String?
    
    var type:Int?
    
    var parentId:String?
    

    
    var userId:String?
    
    var subscribeNum:Int64?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "title":
            self.title = value as? String
        case "imagePath":
            self.imagePath = value as? String
        case "type":
            self.type = value as? Int
        case "parentId":
            self.parentId = value as? String
        
        case "userId":
            self.userId = value as? String
        case "subscribeNum":
            self.subscribeNum = value as? Int64
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.title{
            dic["title"] = v as NSObject
        }
        if  let v = self.imagePath{
            dic["imagePath"] = v as NSObject
        }
        if  let v = self.type{
            dic["type"] = v as NSObject
        }
        if  let v = self.parentId{
            dic["parentId"] = v as NSObject
        }
     
        if  let v = self.userId{
            dic["userId"] = v as NSObject
        }
        if  let v = self.subscribeNum{
            dic["subscribeNum"] = v as NSObject
        }
        
        return dic
    }
}
