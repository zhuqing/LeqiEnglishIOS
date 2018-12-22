//
//  MyContentDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/12/21.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class MyContentDataCache: DataCache<[Content]> {
    public static let instance  = MyContentDataCache()
     var LOG = LOGGER("MyContentDataCache");
    
    private let DATA_TYPE = "MyContentDataCache"
    private let UPDATE_TYPE = "MyContentDataCache_UPDATE_TYPE"
    
    private override init(){
        
    }
    
    
    override func getUpdateTimeType() -> String? {
        return UPDATE_TYPE
    }
    
    //不在同一天就可以刷新
    
    
    override func getFromCache() -> [Content]? {
        
        let datas =  SQLiteManager.instance.readData(type: DATA_TYPE, parentId: UserDataCache.instance.getUserId())
        
        if(datas == nil || datas?.isEmpty ?? true){
            return  nil
        }
        var reciteContentVOs = [Content]()
        for data in datas!{
            reciteContentVOs.append(Content(data: String.toDictionary(data)!))
        }
        
        return reciteContentVOs
        
    }
    
    override func cacheData(data: [Content]?) {
        
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
    
    override func getFromService(finished: @escaping ([Content]?) -> ())  {
        guard let user = UserDataCache.instance.getFromCache() else{
            LOG.error("没有User")
            return;
        }
        
        guard let userId = user.id else{
            LOG.error("userId = nil")
            return
        }
        
        Service.get(path: "english/content/findByUserId?userId=\(userId)"){
            (data) in
            
            guard let datas = Service.getDatas(data: data) else{
                return
            }
            
            
            var contents:[Content]? = [Content]()
            for d in datas{
                contents?.append(ReciteContentVO(data:d))
            }
            
            finished(contents)
        }
    }
}
