//
//  UserDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserDataCache: DataCache<User> {
    
    static private let USER_TYPE = "USER_TYPE"
    static private let sqliteManager = SQLiteManager.instance
    
    static  let userDataCache = UserDataCache()
    
    private var user:User?
    
    private override init() {
        super.init()
    }
    
    override func getFromCache() -> User? {
        
        if(user != nil){
            return user
        }
      
        var datas:[String]? = UserDataCache.sqliteManager.readData(type: UserDataCache.USER_TYPE)
       
        if datas == nil || datas!.count == 0{
           user = createAndSaveUser()
        }else{
            user = User(data:String.toDictionary(datas![0])!)
        }
      
        return user
    }
    
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
         UserDataCache.sqliteManager.delete(type: UserDataCache.USER_TYPE)
         UserDataCache.sqliteManager.insertData(id: user.id!, json: String.toString(user.toDictionary())!, type: UserDataCache.USER_TYPE)
    }
    
    
    private func createAndSaveUser() -> User{
        let user = User()
        user.id = UUID.init().uuidString
        user.name = "Friend"
        UserDataCache.sqliteManager.insertData(id: user.id!, json: String.toString(user.toDictionary())!, type: UserDataCache.USER_TYPE)
        return user
    }
}
