//
//  MyReciteWordConfig.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/27.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyReciteWordConfig: DataCache<ReciteWordConfig> {
    
    static let instance = MyReciteWordConfig()
    
    static let MY_RECITE_WORD_CONFIG_TYPE = "MY_RECITE_WORD_CONFIG_TYPE"
    
    let LOG = LOGGER("MyReciteWordConfig")
    
    
    override func getFromService(finished: @escaping (ReciteWordConfig?) -> ()) {
        guard let user = UserDataCache.instance.getFromCache() else{
            self.LOG.error("没有加载到用户")
            return
        }
        
        Service.get(path: "reciteWordConfig/findByUserId?userId=\(user.id ?? "" )"){ (results ) in
            guard let data = Service.getData(data: results) else{
                self.LOG.error("results:\(results)")
                 finished(nil)
                return
            }
            
           let reciteConfig =  ReciteWordConfig(data: data);
            
            finished(reciteConfig)
            self.cacheData(data: reciteConfig)
        }
    }
    
    override func getFromCache() -> ReciteWordConfig? {
        guard let user = UserDataCache.instance.getFromCache() else{
            self.LOG.error("没有加载到用户")
            return nil
        }
        let dataStr =  SQLiteManager.instance.readData(type: MyReciteWordConfig.MY_RECITE_WORD_CONFIG_TYPE, parentId: user.id ?? "")
        
        guard let arr = dataStr else{
            return nil
        }
        
        if(arr.count == 0){
            return nil
        }
        self.LOG.error("arr.count =\(arr.count )")
        guard let data = String.toDictionary(arr[0]) else{
            return nil
        }
        
        return ReciteWordConfig(data: data)
    }
    
    override func cacheData(data: ReciteWordConfig?) {
        
        guard let user = UserDataCache.instance.getFromCache() else{
            self.LOG.error("没有加载到用户")
            return
        }
        
        guard let d = data else{
             self.LOG.error("数据为nil")
            return
        }
        
         SQLiteManager.instance.delete(id: d.id ?? "")
        
        SQLiteManager.instance.insertData(id: d.id ?? "", json: String.toString(d.toDictionary())!, parentId: user.id ?? "", type: MyReciteWordConfig.MY_RECITE_WORD_CONFIG_TYPE)
    }
}
