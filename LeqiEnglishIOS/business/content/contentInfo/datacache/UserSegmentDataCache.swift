//
//  UserSegmentDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserSegmentDataCache: DataCache<[UserAndSegment]>{
    
    let TYPE = "UserSegmentDataCache"
    
    let UPDATE_TYPE = "UserSegmentDataCache_UPDATE_TYPE"
    
    
    
    private var contentId:String
     init(contentId:String){
         self.contentId = contentId
         super.init()
       
    }
    
    override func getUpdateTimeType() -> String? {
        return UPDATE_TYPE
    }
    
    
    func commit(_ userAndSegment:UserAndSegment){
        Service.post(path: "userAndSegment/create",params: DictionaryUtil.toStringString(data: userAndSegment.toDictionary())){
            (results) in
            self.updatePerscent()
            guard let data = Service.getData(data: results) else{
                return
            }
            
            let userAS = UserAndSegment(data: data)
            
             SQLiteManager.instance.insertData(id: self.getId(id: userAS.id ?? "") , json: userAS.toJSONString(), parentId: self.getParentId(), type: self.TYPE)
            
        }
    }
    
    //百分比
    private func updatePerscent(){
        Service.put(path: "userAndContent/updatePrecent?userId=\(UserDataCache.instance.getUserId())&contentId=\(self.contentId)", finishedCallback: {
            (_) in
        })
    }
    
    override func getFromCache() -> [UserAndSegment]? {
        guard let datas = SQLiteManager.instance.readData(type: TYPE, parentId: self.getCurrentUserId()) else {
            return nil
        }
        
        if(datas.count == 0){
            return nil
        }
        
        var userAndSegemnts = [UserAndSegment]()
        
        for data in datas {
            userAndSegemnts.append(UserAndSegment(data: String.toDictionary(data)!))
        }
        
        return userAndSegemnts
        
    }
    
    override func cacheData(data: [UserAndSegment]?) {
        
        self.claerData()
        
        guard let arr = data else{
            return
        }
        
        for d in arr {
         
            SQLiteManager.instance.insertData(id: self.getId(id: d.id ?? "") , json: d.toJSONString(), parentId: getParentId(), type: TYPE)
        }
    }
    
    private func getId(id:String) -> String {
          return "\(id)-\(self.getCurrentUserId())"
    }
    
    private func getParentId() -> String{
        return "\(self.contentId)--\(self.getCurrentUserId())"
    }
    
    override func claerData() {
       SQLiteManager.instance.delete(type: TYPE, parentId: self.getCurrentUserId())
    }
    
    override func getFromService(finished: @escaping ([UserAndSegment]?) -> ()) {
        guard let user = UserDataCache.instance.getFromCache() else{
            finished(nil)
            return
        }
        
        Service.get(path: "userAndSegment/findByContentIdAndUserId?userId=\(user.id ?? "")&contentId=\(self.contentId)"){
            (results) in
            
            guard let datas = Service.getDatas(data: results) else{
                return
            }
            
            var userAndSegments = [UserAndSegment]()
            
            for data in datas {
                userAndSegments.append(UserAndSegment(data: data))
            }
            
            finished(userAndSegments)
        }
    }
}
