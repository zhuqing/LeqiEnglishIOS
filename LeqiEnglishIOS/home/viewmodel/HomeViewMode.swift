//
//  HomeViewMode.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class HomeViewMode{
    
    func loadUser() -> User {
        Service.get(path: "user/findById", param: ["id" : "id"])
        {
            (result) in
            
            if !Service.isSuccess(data: result) {
                return
            }
            
          //  User(data:Service.getData(data: result))
        }
        return User()
    }
    func loadMyRecitedData(user:User) -> [ReciteContentVO] {
        return [ReciteContentVO]()
    }
    
    func loadMyRecomendDat(user:User)->[Content]{
        return [Content]()
    }
}
