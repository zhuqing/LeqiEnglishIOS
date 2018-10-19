//
//  MyRecitingContentDataCache
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class MyRecitingContentDataCache:DataCache<[ReciteContentVO]>{
    var LOG = LOGGER("MyRecitedViewModel");
    
    static let instance = MyRecitingContentDataCache()
    static let DATA_TYPE = "MyRecitingContentDataCache"
      static let UPDATE_TYPE = "MyRecitingContentDataCache_UPDATE_TYPE"
    private override init(){
        
    }
    
    override func getUpdateTimeType() -> String? {
        return MyRecitingContentDataCache.UPDATE_TYPE
    }
    
    //不在同一天就可以刷新
    override func compareCouldRefresh(oldTime: Int64, newTime: Int64) -> Bool {
        let updateDay = oldTime/(24*60*60*1000)
        let currentDay = newTime/(24*60*60*1000)
        
        return updateDay < currentDay
    }
    
    override func cacheData(data: [ReciteContentVO]?) {
        guard let ds = data else {
            return
        }
        
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        
        self.claerData()
        
        for d in ds{
             SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: user.id, type: MyRecitingContentDataCache.DATA_TYPE)
        }
        
       
    }
    
    
        
    override func claerData() {
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        
        SQLiteManager.instance.delete(type: MyRecitingContentDataCache.DATA_TYPE, parentId: user.id ?? "")
        
    }
   
    override func getFromService(finished: @escaping ([ReciteContentVO]?) -> ())  {
        guard let user = UserDataCache.instance.getFromCache() else{
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
