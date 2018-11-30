//
//  Sentence.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import Foundation
class Sentence : Entity{
    
    
    var english:String?
    
    var chinese:String?
    
    var audioPath:String?
    
    var startTime:Int?
    
    var endTime:Int?
    
    var imagePath:String?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "english":
            self.english = value as? String
        case "chinese":
            self.chinese = value as? String
        case "audioPath":
            self.audioPath = value as? String
        case "startTime":
            self.startTime = value as? Int
        case "endTime":
            self.endTime = value as? Int
        case "imagePath":
            self.imagePath = value as? String
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.english{
            dic["english"] = v as NSObject
        }
        if  let v = self.chinese{
            dic["chinese"] = v as NSObject
        }
        if  let v = self.audioPath{
            dic["audioPath"] = v as NSObject
        }
        if  let v = self.startTime{
            dic["startTime"] = v as NSObject
        }
        if  let v = self.endTime{
            dic["endTime"] = v as NSObject
        }
        if  let v = self.imagePath{
            dic["imagePath"] = v as NSObject
        }
        
        return dic
    }
}
