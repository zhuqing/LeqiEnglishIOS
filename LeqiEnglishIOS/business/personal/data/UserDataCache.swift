//
//  UserDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserDataCache: DataCache<User> {
    
    static  let USER_TYPE = "USER_TYPE"
    
    static  let UPDATE_TYPE = "USER_UPDATE_TYPE"
    
    static  let instance = UserDataCache()
    
    private var user:User?
    
    private override init() {
        super.init()
        
    }
    
    func getUserId()->String{
        if(user != nil && user?.id != nil){
            return user?.id ?? ""
        }
        guard let user = self.getFromCache() else{
            return ""
        }
        self.user = user
        return user.id ?? ""
    }
    
    func getUserName()->String{
        guard let user = self.getFromCache() else{
            return ""
        }
        
        return user.name ?? ""
    }
    
    override func getFromCache() -> User? {
        
        if(user != nil){
            return user
        }
        
        var datas:[String]? = SQLiteManager.instance.readData(type: UserDataCache.USER_TYPE)
        
        if datas == nil || datas!.count == 0{
            user = createAndSaveUser()
        }else{
            user = User(data:String.toDictionary(datas![0])!)
        }
        
        return user
    }
    
    override func refresh() {
        guard let user = self.getFromCache() else{
            return
        }
        
        Service.get(path: "user/findById?id=\(user.id ?? "")"){
            (results) in
            
            guard let data = Service.getData(data: results) else{
                return
            }
            
            self.cacheData(data: User(data:data))
        }
    }
    
    //用户注册
    func regist(user:User,error:((String?)->())?,finished: ((User?) -> ())?){
        
        Service.post(path: "user/regist",params: DictionaryUtil.toStringString(data: user.toDictionary())){
            (results) in
            
            if(!Service.isSuccess(data: results)){
                guard let er = error else{
                    return
                }
                let message = Service.getMessage(data: results)
                
                er(message)
                return
            }
            
            guard let data = Service.getData(data: results) else {
                guard let er = error else{
                    return
                }
                
                er("注册失败")
                
                return
            }
            
            self.user = User(data: data)
          
            self.cacheData(data:self.user)
            
            guard let f = finished else{
                return
            }
            f(self.user)
        }
    }
    
    //根据其他系统的ID获取User数据
    func getUserByOtherSysId(_ otherSysId:String,callback:@escaping (_ user:User?)->()){
        Service.get(path: "user/findUserByOtherSysId?otherSysId=\(otherSysId)"){
            (results) in
            guard let data = Service.getData(data: results) else{
                callback(nil)
                return
            }
            
            let user = User(data: data)
            self.user = user
            self.cacheData(data:self.user)
            callback(user)
        }
    }
    
    //登录
    func login(name:String,password:String,error:((String?)->())?,finished: ((User?) -> ())?) {
        
        Service.get(path: "user/login?userName=\(name)&password=\(password)"){
            (results) in
            if(!Service.isSuccess(data: results)){
                guard let er = error else{
                    return
                }
                let message = Service.getMessage(data: results)
                
                er(message)
                return
            }
            
            guard let data = Service.getData(data: results) else {
                guard let er = error else{
                    return
                }
                
                er("登录失败")
                
                return
            }
            
            self.user = User(data: data)
            self.cacheData(data:self.user)
            
            guard let f = finished else{
                return
            }
            f(self.user)
            
        }
    }
    
    override func getFromService(finished: @escaping (User?) -> ()) {
        
    }
    
    override func cacheData(data:User?){
        guard let user = data else{
            return
        }
        claerData()
        SQLiteManager.instance.insertData(id: user.id!, json: String.toString(user.toDictionary())!, type: UserDataCache.USER_TYPE)
        self.user = data
        AppRefreshManager.instance.clearCacheThenRefresh()
    }
    
    
    override func claerData() {
        SQLiteManager.instance.delete(type: UserDataCache.USER_TYPE)
    }
    
    
    private func createAndSaveUser() -> User{
        let user = User()
        user.id = UUID.init().uuidString
        user.status = 0
        user.name = "Friend"
        SQLiteManager.instance.insertData(id: user.id!, json: String.toString(user.toDictionary())!, type: UserDataCache.USER_TYPE)
        return user
    }
}
