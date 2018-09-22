//
//  StringUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class StringUtil: NSObject {
    
    //句子中中英文的分隔符
    static let CH_EN_SPLITE = ">::<"
    //排除空字符串
    class func exceptEmpty(_ str:String?)->String?{
        if let s = str {
            if(s.count == 0){
                return nil
            }
            return str
        }
        
        return nil
    }
    
    //NSAarry 转换成数组
    class func toString(arr:NSArray)-> String{
        var meanStr:String = ""
        for data in arr{
            meanStr.append("\(data)")
            meanStr.append(",")
        }
        return meanStr
    }
    
    //字符串拆分中文和英文
    class func toChAndEN(str:String)->(String,String){
        let senctendStr:NSString = NSString(string: str)
        
        var arrays = senctendStr.components(separatedBy: CH_EN_SPLITE)
        if arrays.count == 1{
             return (arrays[0],"")
        }
        
        if(arrays[1].elementsEqual("null")){
             return (arrays[0],"")
        }
        
        return (arrays[0],arrays[1])
    }
    
    /**
     Get the height with font.
     
     - parameter font:       The font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    class func computerHeight(text:String ,font : UIFont , fixedWidth : CGFloat) -> CGFloat {
        
        guard text.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width:fixedWidth, height:CGFloat(Int64.max))
        let nsText = NSString(string: text)
   
  
        let rect = nsText.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [   NSAttributedStringKey.font: font], context:nil)
        
        return rect.size.height
    }
}
