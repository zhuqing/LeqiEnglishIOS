//
//  SegmentUserHeartedDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/8.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class UserHeartedDataCache: DataCache<UserHearted> {
    private var segmentId:String
    private var DATA_TYPE = "UserHeartedDataCache"
    init(segmentId:String) {
        self.segmentId = segmentId
    }
    
    override  func cacheData(data: UserHearted?) {
        guard let d = data else{
            return
        }
        let userId = UserDataCache.instance.getUserId()
        SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: "\(userId)-\(d.targetId ?? "")", type: DATA_TYPE)
    }
    
    //清理掉以前的数据
    override func claerData() {
        super.claerData()
        let userId = UserDataCache.instance.getUserId()
        SQLiteManager.instance.delete(type: DATA_TYPE, parentId: "\(userId)-\(segmentId)")
        
    }
    
    override func getFromCache() -> UserHearted? {
        let userId = UserDataCache.instance.getUserId()
        let datas = SQLiteManager.instance.readData(type: DATA_TYPE, parentId: "\(userId)-\(segmentId)")
        
        
        if(datas == nil || datas?.isEmpty ?? true){
            return  nil
        }
       
        for data in datas!{
             return UserHearted(data: String.toDictionary(data)!)
        }
        
        return nil
    }
    
    
    override func getFromService(finished: @escaping (UserHearted?) -> ()) {
        let userId = UserDataCache.instance.getUserId()
        Service.get(path: "/userHearted/findByUserIdAndTargetId?userId=\(userId)&targetId=\(self.segmentId)"){
            (datas) in
            guard let arr = Service.getDatas(data: datas) else{
                finished(nil)
                return
            }
            
            if(arr.isEmpty){
                 finished(nil)
                return
            }
           
            let userHearted = UserHearted(data: (arr.first)!)
            finished(userHearted)
            
        }
    }
    
    
}
