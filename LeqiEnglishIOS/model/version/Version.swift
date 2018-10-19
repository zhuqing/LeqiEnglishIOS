//
//  Version.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/17.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class Version : Entity{
    
    
    var versionNo:Int64?
    
    var versionCode:String?
    
    var message:String?
    
    var filePath:String?
    
    var type:Int?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "versionNo":
            self.versionNo = value as? Int64
        case "versionCode":
            self.versionCode = value as? String
        case "message":
            self.message = value as? String
        case "filePath":
            self.filePath = value as? String
        case "type":
            self.type = value as? Int
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.versionNo{
            dic["versionNo"] = v as NSObject
        }
        if  let v = self.versionCode{
            dic["versionCode"] = v as NSObject
        }
        if  let v = self.message{
            dic["message"] = v as NSObject
        }
        if  let v = self.filePath{
            dic["filePath"] = v as NSObject
        }
        if  let v = self.type{
            dic["type"] = v as NSObject
        }
        
        return dic
    }
}
