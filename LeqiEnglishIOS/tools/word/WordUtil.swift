//
//  WordUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/22.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordUtil: NSObject {
    class func getMeans(item:Word) -> String{
        guard let means = item.means else {
            return ""
        }
        
        
        guard let meanDatas = String.toDictionarys(means) else {
            return ""
        }
        
        var meanStr:String = ""
        for data in meanDatas{
            let arr = data["means"] as! NSArray
            meanStr.append("\(data["part"]!)\t \(StringUtil.toString(arr:arr))\n")
        }
        
        return meanStr
    }
}
