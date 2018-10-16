//
//  UserReciteRecord.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/16.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserReciteRecordDataCache: DataCache<UserReciteRecord> {
    
    let LOG = LOGGER("UserReciteRecordDataCache")
    
    static let instance = UserReciteRecordDataCache()
    
    static let TYPE = "UserReciteRecordDataCache"
    
    static let UPDATE_TYPE = "UserReciteRecordDataCache_UPDATE_TYPE"
    
    private override init(){
        super.init()
        AppRefreshManager.instance.regist(self)
    }
    
    override func getFromCache() -> UserReciteRecord? {
        guard let user = UserDataCache.instance.getFromCache() else {
            return nil
        }
        guard let datas =  SQLiteManager.instance.readData(type: UserReciteRecordDataCache.TYPE, parentId: user.id ?? "")  else{
            return nil
        }
        
        if (datas.count == 0){
            return nil
        }
        
        return UserReciteRecord(data: String.toDictionary(datas[0])!)
    }
    
    override func isRefresh() -> Bool {
        guard let datas =  SQLiteManager.instance.readData(type: UserReciteRecordDataCache.UPDATE_TYPE)  else{
            super.insertUpdateTime(UserReciteRecordDataCache.UPDATE_TYPE)
            return true
        }
        
        let update = self.getUpdateTime(UserReciteRecordDataCache.UPDATE_TYPE)
        super.insertUpdateTime(UserReciteRecordDataCache.UPDATE_TYPE)
        if(update == 0){
            return true
        }
        let updateDay = update/(24*60*60*1000)
        let currentDay = NSDate.getTime()/(24*60*60*1000)
        
        LOG.info("update:\(update)\tupdateDay:\(updateDay)\tcurrentDay:\(currentDay)")
        
        return updateDay < currentDay
    }
    
    override func getFromService(finished: @escaping (UserReciteRecord?) -> ()) {
        guard let user = UserDataCache.instance.getFromCache() else{
            finished(nil)
            return
        }
        Service.get(path: "userReciteRecord/findByUserId?userId=\(user.id ?? "")"){
            (results) in
            
            guard let data = Service.getData(data: results) else{
                 finished(nil)
                return
            }
            
            finished(UserReciteRecord(data: data))
            
        }
    }
    
    override func claerData() {
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        
        SQLiteManager.instance.delete(type: UserReciteRecordDataCache.TYPE, parentId:user.id ?? "")
    }
    
    override func refresh() {
        self.getFromService(){
            (userData) in
            self.cacheData(data: userData)
        }
    }
    
    
    override func cacheData(data: UserReciteRecord?) {
        guard let userRR = data else{
            return
        }
        
       claerData()
        
       SQLiteManager.instance.insertData(id: userRR.id ?? "" , json: userRR.toJSONString(),parentId: userRR.userId ?? "", type:UserReciteRecordDataCache.TYPE )
    }
}
