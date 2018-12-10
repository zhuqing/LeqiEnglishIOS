//
//  VersionDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/17.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class VersionDataCache: DataCache<Version> {
    
    static let instance = VersionDataCache()
    
     let DATA_TYPE = "VersionDataCache"
    
    let currentVersion:Int64 = 100001
    
    var newVersion:Version?
    
    private override init() {

    }
    
    
    //检测是否需要更新
    func checkUpdate(callback:@escaping (Version?)->()){
        self.getFromService(){
            (version) in
            guard let newVersion = version else{
                callback(nil)
                return
            }
           
            
            let newVersionNo = newVersion.versionNo ?? 0
            
            if (newVersionNo > self.currentVersion){
              
                callback(newVersion)
            }else{
                callback(nil)
            }
            
           
            
        }
    }
    
    override func cacheData(data: Version?) {
        guard let d = data else {
            return
        }
        claerData()
        SQLiteManager.instance.insertData(id: d.id ?? "" , json: d.toJSONString(), type: DATA_TYPE)
        
    }
    
    override func claerData() {
        
         SQLiteManager.instance.delete(type: DATA_TYPE)
    }
    
    override func getFromCache() -> Version? {
        guard let datas = SQLiteManager.instance.readData(type: DATA_TYPE) else {
            return nil
        }
        
        if(datas.count == 0){
            return nil
        }
        
        return Version(data: String.toDictionary(datas[0])! )
        
    }
    
    override func getFromService(finished: @escaping (Version?) -> ()) {
        
        if(newVersion != nil){
            finished(newVersion)
            return
        }
        
        Service.get(path: "version/findNewestByType?type=\(401)"){
            (results) in
            guard let data = Service.getData(data: results) else {
                finished(nil)
                return
            }
            self.newVersion = Version(data: data)
            finished(self.newVersion)
        }
    }
}
