//
//  String_extension.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/14.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

extension String {
    
   static func toString(_ dic:[String : NSObject]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    // MARK: 字符串转字典
   static func toDictionary(_ str: String) -> [String : NSObject]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : NSObject] {
            return dict
        }
        return nil
    }
    

    static func toDictionarys(_ value:String) ->[[String:NSObject]]?{
        let jsonData = value.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with:jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String : NSObject]]{
            return dict
        }
        return nil
        
    }
}
