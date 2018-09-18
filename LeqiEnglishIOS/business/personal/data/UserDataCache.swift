//
//  UserDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserDataCache: DataCache<User> {
    
    static let USER_TYPE = "USER_TYPE"
    var sqliteManager = SQLiteManager()
    
    var user:User?
    
    override func getFromCache() -> User? {
        
        if(user != nil){
            return user
        }
      
        var datas:[String]? = sqliteManager.readData(type: UserDataCache.USER_TYPE)
       
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
        var user = User()
        user.id = UUID.init().uuidString
        user.name = "Friend"
        sqliteManager.insertData(id: user.id!, json: String.toString(user.toDictionary())!, type: UserDataCache.USER_TYPE)
        return user
    }
}
