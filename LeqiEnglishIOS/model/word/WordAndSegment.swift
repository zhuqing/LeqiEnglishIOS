//
//  WordAndSegment.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordAndSegment : Entity{
    
    
    var word:String?
    
    var segmentId:String?
    
    var contentId:String?
    
    var contentTitle:String?
    
    var wordId:String?
    
    var scentenceIndex:Int?
    
    var scentence:String?
    
    var startTime:Int64?
    
    var endTime:Int64?
    
    var audioPath:String?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "word":
            self.word = value as? String
        case "segmentId":
            self.segmentId = value as? String
        case "contentId":
            self.contentId = value as? String
        case "contentTitle":
            self.contentTitle = value as? String
        case "wordId":
            self.wordId = value as? String
        case "scentenceIndex":
            self.scentenceIndex = value as? Int
        case "scentence":
            self.scentence = value as? String
        case "startTime":
            self.startTime = value as? Int64
        case "endTime":
            self.endTime = value as? Int64
        case "audioPath":
            self.audioPath = value as? String
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.word{
            dic["word"] = v as NSObject
        }
        if  let v = self.segmentId{
            dic["segmentId"] = v as NSObject
        }
        if  let v = self.contentId{
            dic["contentId"] = v as NSObject
        }
        if  let v = self.contentTitle{
            dic["contentTitle"] = v as NSObject
        }
        if  let v = self.wordId{
            dic["wordId"] = v as NSObject
        }
        if  let v = self.scentenceIndex{
            dic["scentenceIndex"] = v as NSObject
        }
        if  let v = self.scentence{
            dic["scentence"] = v as NSObject
        }
        if  let v = self.startTime{
            dic["startTime"] = v as NSObject
        }
        if  let v = self.endTime{
            dic["endTime"] = v as NSObject
        }
        if  let v = self.audioPath{
            dic["audioPath"] = v as NSObject
        }
        
        return dic
    }

}
