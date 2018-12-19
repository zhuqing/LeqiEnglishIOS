//
//  PageDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/12/17.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class PageDataCache<T>: DataCache<T> {
    var page = 1;
    var pageSize = PAGE_SIZE;
    
    //分页加载更多的数据
    public func loadMore( page:Int ,  pageSize:Int ,finished:@escaping (_ ts:T?)->()){
        
        self.getMoreFromService(page: page, pageSize: pageSize){
            (ts) in
            finished(ts)
            //把加载的数据放入缓存
            DispatchQueueUtil.run(excutor: {() in
                   self.cacheData(data: ts)
            }, callback: {() in
                
            })
         
         
        }
        
     
    }
    
    
    public func getMoreFromService(page:Int ,  pageSize:Int ,finished:@escaping (_ ts:T?)->()){
        
    }
    
    public func getPageParam(page:Int ,  pageSize:Int )->String{
        return "page=\(page)&pageSize=\(pageSize)"
    }
}
