//
//  String_extension.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/14.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import Foundation


extension String {
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
   
    
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
