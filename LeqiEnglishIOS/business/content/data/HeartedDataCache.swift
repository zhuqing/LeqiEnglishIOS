//
//  HeartedDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/7.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class HeartedUtil {
    //用户对文章点赞
    class func contentHeated(targetId:String){
        let userId = UserDataCache.instance.getUserId()
        Service.put(path: "/english/content/awesome?userId=\(userId)&id=\(targetId)"){
            (result) in
            let singleContent = SingleContent(contentId: targetId)
            singleContent.updateDatabase()
        }
    }
    
    //对段点赞
    class func segmentHeated(targetId:String,contentId:String){
        
        let userId = UserDataCache.instance.getUserId()
        Service.put(path: "/segment/awesome?userId=\(userId)&id=\(targetId)"){
            (result) in
            let segmentDataCache = SegmentDataCache(id:targetId)
            segmentDataCache.updateData(contentId: contentId)
          
        }
    }
    
    //更新segment的点赞数
    class func updateAwesome(root:UIView,segment:Segment?,heartedIndex:Int,userInteract:Bool){
        
        
        guard let s = segment else{
            OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("赞","heart"))
            return
        }
        
        if((s.awesomeNum ?? 0) == 0){
            OperationBarViewUtil.updateOperationItemTitle(root: root, index: heartedIndex, itemData:("赞","heart"))
            return
        }
        
        if(userInteract){
            OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart_red"))
            return
        }
        
        OperationBarViewUtil.updateOperationItemTitle(root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart"))
        
        //加载并判断当前用户是否已经点赞了
        let cache = UserHeartedDataCache(segmentId: s.id ?? "")
        cache.load(){
            (userHearted) in
            guard userHearted != nil else{
                OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart"))
                return
            }
            
            OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart_red"))
            
        }
        
        
    }
    
    
    //更新segment的点赞数
    class func updateAwesome(root:UIView,content:Content?,heartedIndex:Int,userInteract:Bool){
        
        
        guard let s = content else{
            OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("赞","heart"))
            return
        }
        
        if((s.awesomeNum ?? 0) == 0){
            OperationBarViewUtil.updateOperationItemTitle(root: root, index: heartedIndex, itemData:("赞","heart"))
            return
        }
        
        if(userInteract){
            OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart_red"))
            return
        }
        
        OperationBarViewUtil.updateOperationItemTitle(root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart"))
        
        //加载并判断当前用户是否已经点赞了
        let cache = UserHeartedDataCache(segmentId: s.id ?? "")
        cache.load(){
            (userHearted) in
            guard userHearted != nil else{
                OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart"))
                return
            }
            
            OperationBarViewUtil.updateOperationItemTitle( root: root, index: heartedIndex, itemData:("\(s.awesomeNum ?? 0)","heart_red"))
            
        }
        
        
    }
    
        
}
