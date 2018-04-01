//
//  Entity.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/4/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class Entity{
    var id:String
    var createTime:String
    var updateTime:String
    var status:String
    
    init(id:String,createTime:String,updateTime:String,status:String) {
        self.id = id
        self.createTime = createTime
        self.updateTime = updateTime
        self.status = status
    }
    
    convenience init(){
        self.init(id: "", createTime: "", updateTime: "", status: "")
    }
    
}
