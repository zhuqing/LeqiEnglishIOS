//
//  MyRecitedViewModel.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class MyRecitedViewModel:DataCache<[ReciteContentVO]>{
    var LOG = LOGGER("MyRecitedViewModel");
   
    override func getFromService(finished: @escaping ([ReciteContentVO]?) -> ())  {
        let userData = UserDataCache.userDataCache
        guard let user = userData.getFromCache() else{
            LOG.error("没有User")
            return;
        }
        
        guard let userId = user.id else{
             LOG.error("userId = nil")
            return
        }
        
        Service.get(path: "english/content/findUserReciting?userId=\(userId)"){
            (data) in
            
            let datas = Service.getDatas(data: data)
            
            var contents:[ReciteContentVO]? = [ReciteContentVO]()
            for d in datas!{
                contents?.append(ReciteContentVO(data:d))
            }
            
            finished(contents)
        }
    }
}
