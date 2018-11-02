//
//  HomeViewMode.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class AppRefreshManager{
    private var refreshList = [RefreshDataCacheDelegate]()
    private var refreshDic = [String:RefreshDataCacheDelegate]()
    
    static let instance = AppRefreshManager()
    
    private init(){
        
    }
    
    func regist(id:String , _ refreshDataCache:RefreshDataCacheDelegate){
       refreshDic[id] = refreshDataCache
    }
    
    func remove(id:String){
      refreshDic[id] = nil
    }
    
    func refresh(){
        for (_,ref) in refreshDic {
            ref.refresh()
        }
    }
}
