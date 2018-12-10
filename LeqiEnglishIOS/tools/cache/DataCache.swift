//
//  LoadData.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class DataCache<T> :RefreshDataCacheDelegate{
   
    
    
    private let LOG = LOGGER("DataCache")
    
    var cacheData:T?
    
    //从服务端获取数据
    func getFromService(finished:@escaping (_ ts:T?)->()){}
    
    //从缓存中获取数据
    func getFromCache()->T?{return nil}
    
    //加载数据
    func load(finished:@escaping (_ ts:T?)->()){
        if(!Service.isConnect){
            loadDataFromCache(finished: finished)
            return
        }
        
        //是否需要刷新，如需要直接从服务端加载并
        if(!isRefresh()){//isRefresh = false ,不需要刷新
            
            if(cacheData != nil){//有已经加载的缓存数据
                finished(cacheData!)
                checkAndLoadNewset(finished: finished)
                return
            }
            
            //异步从缓存中加载
            DispatchQueueUtil.run(excutor: {() in
                self.cacheData =  self.getFromCache()
            }, callback: {() in
                if(self.cacheData != nil){
                     finished(self.cacheData)
                     self.checkAndLoadNewset(finished: finished)
                }else{
                    //从服务端加载并放入缓存
                    self.getFromService(finished: {
                        (ts) in
                        self.cacheData = ts
                        self.cacheData(data: ts)
                        finished(ts)
                    })
                }
               
            })
            return
           
        }else{//isRefresh = true ,需要刷新缓存,先从缓存中加载数据，然后从服务端加载数据
            
            loadDataFromCache(finished: finished)
        }
        
        if(!Service.isConnect){
            return;
        }
        
        //从服务端加载并放入缓存
        getFromService(finished: {
            (ts) in
            self.cacheData(data: ts)
            self.cacheData = ts
            finished(ts)
        })
    }
    
    func checkAndLoadNewset(finished:@escaping (_ ts:T?)->())  {
      
    }
    
    private func loadDataFromCache(finished:@escaping (_ ts:T?)->()){
        if(cacheData != nil){//有已经加载的缓存数据
            finished(cacheData!)
            return
        }
        
        
        //异步从缓存中加载
        DispatchQueueUtil.run(excutor: {() in
            self.cacheData =  self.getFromCache()
        }, callback: {() in
            if(self.cacheData != nil){
                finished(self.cacheData)
            }
            
        })
        
    }
    
    //加载数据
    func loadAndThenRefresh(finished:@escaping (_ ts:T?)->()){
        
        //是否需要刷新，如需要直接从服务端加载并
        if(!isRefresh()){
            if let data = getFromCache(){
                finished(data)
                return
            }
        }else{
            //如果有缓存数据，获取缓存数据，刷新缓存数据
            if let data = getFromCache(){
                finished(data)
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
  
    
    //是否刷新数据
    func isRefresh() -> Bool {
        guard let updateTimeType = self.getUpdateTimeType() else{
            return false
        }
        
        guard SQLiteManager.instance.readData(type: updateTimeType) != nil  else{
            self.insertUpdateTime(updateTimeType)
            return false
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
        
        LOG.info("\(updateDay),\(currentDay)")
        
        return updateDay < currentDay
    }
    
    func getId() -> String {
        return ""
    }
    
    //清空缓存
    func claerData(){
        cacheData = nil
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
        //异步执行
        DispatchQueueUtil.run(excutor: {() in
            SQLiteManager.instance.delete(type: type)
            SQLiteManager.instance.insertData(id: type, json: "\(NSDate.getTime())", type: type)
        }, callback: nil)
      
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
    //
    func clearnCacheThenRefresh() {
        self.cacheData = nil
        self.claerData()
        refresh()
    }
    
    
    //重新刷新缓存中的数据
    func refresh(){
        
        if(!Service.isConnect){
            return;
        }
        
        DispatchQueueUtil.run(excutor: {() in
            self.getFromService(){
                (data) in
                self.cacheData = data
                self.cacheData(data: data)
            }
        }, callback:nil)
       
    }
}
