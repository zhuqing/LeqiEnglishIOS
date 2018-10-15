//
//  LoadData.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class DataCache<T> :RefreshDataCacheDelegate{
    func getFromService(finished:@escaping (_ ts:T?)->()){}
    func getFromCache()->T?{return nil}
    func load(finished:@escaping (_ ts:T?)->()){
        if let data = getFromCache(){
            finished(data)
            return
        }
        getFromService(finished: {
            (ts) in
            self.cacheData(data: ts)
            finished(ts)
        })
    }
    
    func cacheData(data:T?){}
    
    func refresh(){
        getFromService(){
            (data) in
            self.cacheData(data: data)
        }
    }
    
    func getId() -> String {
       return ""
    }
}


