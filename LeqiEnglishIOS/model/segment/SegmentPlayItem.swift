//
//  File.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit

class SegmentPlayItem{
   static let  LOG = LOGGER("SegmentPlayItem")
    
    var englishSenc:String?
    var chineseSenc:String?
    
    var startTime:Int64?
    var endTime:Int64?
    
   
    init() {
        
    }
    
    class func toItems(str:String)->[SegmentPlayItem]?{
        let nsStr:NSString = NSString(string: str)
        let subStrings:[String] = nsStr.components(separatedBy: "\n")
        var segmentPlayItems = [SegmentPlayItem]()
        
        for item  in subStrings{
            
            let nsItem:NSString = NSString(string: item)
            if nsItem.length == 0 {
                continue
            }
            let segmentPlayItem = SegmentPlayItem()
             
            var arrays = nsItem.components(separatedBy: "==>")
            
        
            if(arrays.count != 2){
                //  SegmentPlayItem.LOG.error("1\(arrays[1]),count=\(arrays.count)")
                SegmentPlayItem.LOG.error("1.\(item),count=\(arrays.count)")
                return nil;
            }
            
            segmentPlayItem.startTime = NSString(string: arrays[0]).longLongValue
       
            
            let endSubString:NSString = NSString(string: arrays[1])
            
            arrays = endSubString.components(separatedBy:"-->")
            
            if(arrays.count != 2){
                 SegmentPlayItem.LOG.error("2.\(arrays[1]),count=\(arrays.count)")
                return nil
            }
            
            segmentPlayItem.endTime = NSString(string: arrays[0]).longLongValue
            
            let senctendStr:NSString = NSString(string: arrays[1])
            
            arrays = senctendStr.components(separatedBy: ">::<")
            
            segmentPlayItem.englishSenc = arrays[0]
            if(arrays.count == 2){
              
                segmentPlayItem.chineseSenc = arrays[1]
            }
            
            segmentPlayItems.append(segmentPlayItem)
            
        }
        return segmentPlayItems
    }
}
