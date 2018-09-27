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
    static private let sqliteManager = SQLiteManager()
    
    static  let userDataCache = UserDataCache()
    
    var user:User?
    
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
    
    func login(name:String,password:String) -> User? {
        return nil
    }
    
    override func getFromService(finished: @escaping (User?) -> ()) {
     
    }
    
    
    private func createAndSaveUser() -> User{
        let user = User()
        user.id = UUID.init().uuidString
        user.name = "Friend"
        UserDataCache.sqliteManager.insertData(id: user.id!, json: String.toString(user.toDictionary())!, type: UserDataCache.USER_TYPE)
        return user
    }
}
