//
//  MyReciteWordConfig.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/27.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyReciteWordConfig: DataCache<ReciteWordConfig> {
    
    static let myReciteWordConfig = MyReciteWordConfig()
    
    static let MY_RECITE_WORD_CONFIG_TYPE = "MY_RECITE_WORD_CONFIG_TYPE"
    
    let LOG = LOGGER("MyReciteWordConfig")
    
    
    override func getFromService(finished: @escaping (ReciteWordConfig?) -> ()) {
        guard let user = UserDataCache.userDataCache.getFromCache() else{
            self.LOG.error("没有加载到用户")
            return
        }
        
        Service.get(path: "reicteWordConfig/findByUserId?userId=\(user.id ?? "" )"){ (results ) in
            guard let data = Service.getData(data: results) else{
                self.LOG.error("results:\(results)")
                return
            }
            
           let reciteConfig =  ReciteWordConfig(data: data);
           
            finished(reciteConfig)
        }
    }
}
