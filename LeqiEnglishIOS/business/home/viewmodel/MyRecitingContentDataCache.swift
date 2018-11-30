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
    private let DATA_TYPE = "MyRecitingContentDataCache"
    static let UPDATE_TYPE = "MyRecitingContentDataCache_UPDATE_TYPE"
    
    private override init(){
        
    }
    
    override func getUpdateTimeType() -> String? {
        return MyRecitingContentDataCache.UPDATE_TYPE
    }
    
    //不在同一天就可以刷新
   
    
    override func getFromCache() -> [ReciteContentVO]? {
      
        let datas =  SQLiteManager.instance.readData(type: DATA_TYPE, parentId: UserDataCache.instance.getUserId())
        
      
        if(datas == nil || datas?.isEmpty ?? true){
            return  nil
        }
        var reciteContentVOs = [ReciteContentVO]()
        for data in datas!{
            reciteContentVOs.append(ReciteContentVO(data: String.toDictionary(data)!))
        }
        
        return reciteContentVOs
        
    }
    
    override func cacheData(data: [ReciteContentVO]?) {
        guard let ds = data else {
            return
        }
      

        for d in ds{
             SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: UserDataCache.instance.getUserId(), type: DATA_TYPE)
        }
        
       
    }
    
    
    //清理掉以前的数据
    override func claerData() {
        super.claerData()
        SQLiteManager.instance.delete(type: DATA_TYPE, parentId: UserDataCache.instance.getUserId())
        
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
            
            guard let datas = Service.getDatas(data: data) else{
                return
            }
          
           
            var contents:[ReciteContentVO]? = [ReciteContentVO]()
            for d in datas{
                contents?.append(ReciteContentVO(data:d))
            }
            
            finished(contents)
        }
    }
}
