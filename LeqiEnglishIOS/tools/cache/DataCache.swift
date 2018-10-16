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
        return false
    }
    
    func getId() -> String {
        return ""
    }
    
    //插入数据更新的时间
    func insertUpdateTime(_ type:String){
        SQLiteManager.instance.delete(type: type)
        SQLiteManager.instance.insertData(id: type, json: "\(NSDate.getTime())", type: type)
    }
    
    func claerData(){
        
    }
    
    //获取数据更新的时间
    func getUpdateTime(_ type:String)->Int64{
        guard let datas = SQLiteManager.instance.readData(type: type) else {
            return 0
        }
        
        if datas.count == 0{
            return 0
        }
        
        return Int64(datas[0])!
    }
}


