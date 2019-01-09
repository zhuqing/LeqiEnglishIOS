//
//  Segment.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/17.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class Segment : Entity{
    
    
    var title:String?
    
    var content:String?
    
    var userId:String?
    
    var contentId:String?
    
    var audioPath:String?
    
    var readNum:Int64?
    
    var indexNo:Int?
    
    var awesomeNum:Int?
    
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
        case "content":
            self.content = value as? String
        case "userId":
            self.userId = value as? String
        case "contentId":
            self.contentId = value as? String
        case "audioPath":
            self.audioPath = value as? String
        case "readNum":
            self.readNum = value as? Int64
        case "indexNo":
            self.indexNo = value as? Int
        case "awesomeNum":
            self.awesomeNum = value as? Int
            
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
        if  let v = self.content{
            dic["content"] = v as NSObject
        }
        if  let v = self.userId{
            dic["userId"] = v as NSObject
        }
        if  let v = self.contentId{
            dic["contentId"] = v as NSObject
        }
        if  let v = self.audioPath{
            dic["audioPath"] = v as NSObject
        }
        if  let v = self.readNum{
            dic["readNum"] = v as NSObject
        }
        if  let v = self.indexNo{
            dic["indexNo"] = v as NSObject
        }
        if  let v = self.awesomeNum{
            dic["awesomeNum"] = v as NSObject
        }
        
        return dic
    }
}
