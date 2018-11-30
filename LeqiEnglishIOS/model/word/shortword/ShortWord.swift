//
//  ShortWord.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import Foundation
class ShortWord : Entity{
    
    
    var word:String?
    
    var info:String?
    
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
        case "info":
            self.info = value as? String
            
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
        if  let v = self.info{
            dic["info"] = v as NSObject
        }
        
        return dic
    }
}
