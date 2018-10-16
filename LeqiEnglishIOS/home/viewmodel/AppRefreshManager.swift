//
//  HomeViewMode.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class AppRefreshManager{
    var refreshList = [RefreshDataCacheDelegate]()
    
    static let instance = AppRefreshManager()
    
    private init(){
        
    }
    
    func regist(_ refreshDataCache:RefreshDataCacheDelegate){
        refreshList.append(refreshDataCache)
    }
    
    func remove(_ refreshDataCache:RefreshDataCacheDelegate){
       guard let index =  refreshList.index(where: {
            (re) in
            return re.getId() == refreshDataCache.getId()
       }) else {
        return
        }
        refreshList.remove(at: index)
    }
    
    func refresh(){
        for refresh in refreshList {
            refresh.refresh()
        }
    }
}
