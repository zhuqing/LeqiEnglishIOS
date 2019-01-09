//
//  HeartedDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/7.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class HeartedDataCache: DataCache<UserHearted> {
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
        
}
