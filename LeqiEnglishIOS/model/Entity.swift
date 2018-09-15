//
//  Entity.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/4/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit
class Entity :NSObject{
    var id:String?
    var createDate:Int64?
    var updateDate:Int64?
    var status:Int?
  
    override init() {
       
    }
    convenience init(data:[String:AnyObject]) {
      self.init()
      setValuesForKeys(data)
    }
    
   
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "id":
            self.id = value as? String
        case "createDate":
            self.createDate = value as? Int64
        case "updateDate":
            self.updateDate = value as? Int64
            
        case "status":
            self.status = value as? Int
        default:
           
            break
        }
    }
    
    func toDictionary()->[String:NSObject]{
        var dic = [String:NSObject]()
        if  let v = self.id {
            dic["id"] = v as NSObject
        }
        if  let v = self.createDate {
            dic["createDate"] = v as NSObject
        }
        if  let v = self.updateDate {
            dic["updateDate"] = v as NSObject
        }
        if  let v = self.status {
            dic["status"] = v as NSObject
        }
        return dic
    }
}
