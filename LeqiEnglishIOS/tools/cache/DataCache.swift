//
//  LoadData.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class DataCache<T> :RefreshDataCacheDelegate{
    
    //从服务端获取数据
    func getFromService(finished:@escaping (_ ts:T?)->()){}
    
    //从缓存中获取数据
    func getFromCache()->T?{return nil}
    
    //加载数据
    func load(finished:@escaping (_ ts:T?)->()){
        
        //是否需要刷新，如需要直接从服务端加载并
        if(!isRefresh()){
            if let data = getFromCache(){
                finished(data)
                return
            }
        }
        //从服务端加载并放入缓存
        getFromService(finished: {
            (ts) in
            self.cacheData(data: ts)
            finished(ts)
        })
    }
    
    //缓存数据
    func cacheData(data:T?){}
    
    //刷新数据
    func refresh(){
        getFromService(){
            (data) in
            self.cacheData(data: data)
        }
    }
    
    //是否刷新数据
    func isRefresh() -> Bool {
        guard let updateTimeType = self.getUpdateTimeType() else{
            return true
        }
        
        guard let datas =  SQLiteManager.instance.readData(type: updateTimeType)  else{
            self.insertUpdateTime(updateTimeType)
            return true
        }
        
        let update = self.getUpdateTime(updateTimeType)
        self.insertUpdateTime(updateTimeType)
        if(update == 0){
            return true
        }
        
        return self.compareCouldRefresh(oldTime: update, newTime: NSDate.getTime())
        
        
    }
    
    func getUpdateTimeType()->String?{
        return nil
    }
    //比较两个日期，默认一天更新一次
    func compareCouldRefresh(oldTime:Int64 , newTime:Int64) -> Bool{
        let updateDay = oldTime/(24*60*60*1000)
        let currentDay = newTime/(24*60*60*1000)
        
        return updateDay < currentDay
    }
    
    func getId() -> String {
        return ""
    }
    
    
    func claerData(){
        
    }
    
    //获取当前登录的用户的ID
    func getCurrentUserId() ->String{
        guard let user = UserDataCache.instance.getFromCache() else{
            return ""
            
        }
        
        return user.id ?? ""
        
    }
    
    //插入数据更新的时间
    private func insertUpdateTime(_ type:String){
        SQLiteManager.instance.delete(type: type)
        SQLiteManager.instance.insertData(id: type, json: "\(NSDate.getTime())", type: type)
    }
  
    
    //获取数据更新的时间
    private func getUpdateTime(_ type:String)->Int64{
        guard let datas = SQLiteManager.instance.readData(type: type) else {
            return 0
        }
        
        if datas.count == 0{
            return 0
        }
        
        return Int64(datas[0])!
    }
}


