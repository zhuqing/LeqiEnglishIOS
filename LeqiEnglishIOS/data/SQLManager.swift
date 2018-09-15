//
//  SQLManager.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import SQLite

struct SQLiteManager {
    
    private var db: Connection!
    private let cacheTable = Table("CACHE_TABLE") //表名
    private let ID = Expression<String>("ID")      //主键
    private let JSON = Expression<String>("JSON")  //列表1
    private let PARENT_ID = Expression<String?>("PARENT_ID") //列表2
    private let TYPE = Expression<String>("TYPE") //列表2
    private let CREATE_DATE = Expression<Int64>("CREATE_DATE") //列表2
    private let UPDATE_DATE = Expression<Int64>("UPDATE_DATE") //列表2
    
    static let USER_TYPE = "USER_TYPE"
    
    static let CONTENT_TYPE = "CONTENT_TYPE"
    
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3(filePath: String = "/Documents")  {
        
        let sqlFilePath = NSHomeDirectory() + filePath + "/db2.sqlite3"
        do {
            db = try Connection(sqlFilePath)
           
            try db.run(cacheTable.create { t in
                t.column(ID, primaryKey: true)
                t.column(JSON)
                t.column(PARENT_ID)
                t.column(TYPE)
                t.column(CREATE_DATE)
                t.column(UPDATE_DATE)
            })
        } catch { print(error) }
    }
    
    //插入数据
    func insertData(id:String,json:String, parentId:String?=nil,type:String){
        do {
            if let pId = parentId{
                let insert = cacheTable.insert(ID <- id, JSON <- json,PARENT_ID <- pId,TYPE <- type,CREATE_DATE <- NSDate.getTime(),UPDATE_DATE <- NSDate.getTime())
                try db.run(insert)
            }else{
                let insert = cacheTable.insert(ID <- id, JSON <- json,PARENT_ID <- nil,TYPE <- type,CREATE_DATE <- NSDate.getTime(),UPDATE_DATE <- NSDate.getTime())
                try db.run(insert)
            }
        } catch {
            print(error)
        }
    }
    
    //读取数据
    func readData(id:String) -> String?{
        let queryTable = cacheTable.select(JSON).filter(ID == id)
        do{
            for data in try db.prepare(queryTable){
                return data[JSON]
            }
        }catch{
            print(error)
        }
        return nil
    }
    
    //读取数据
    func readData(type:String) -> [String]?{
        let queryTable = cacheTable.select(JSON).filter(TYPE == type)
        
            return readData(queryTable)
    }
    
    //读取数据
    func readData(parentId:String) -> [String]?{
        let queryTable = cacheTable.select(JSON).filter(PARENT_ID == parentId)
        
            return readData(queryTable)
    }
    
    //读取数据
    func readData(type:String,parentId:String) -> [String]?{
        let queryTable = cacheTable.select(JSON).filter(TYPE == type).filter(PARENT_ID == parentId)
        
      
        return readData(queryTable)
    }
    
    //读取数据
    func readData(type:String? = nil,parentId:String? = nil,id:String? = nil) -> [String]?{
        var queryTable = cacheTable
        if let t = type{
            queryTable = queryTable.select(TYPE == t)
        }
        
        if let pid = parentId{
             queryTable = queryTable.select(PARENT_ID == pid)
        }
        
        if let idT = id{
            queryTable = queryTable.select(ID == idT)
        }
        
      
        
        return readData(queryTable)
    }
    
    
    private func readData(_ queryTable:Table) ->[String]?{
        
        do{
            var datas:[String] = [String]()
            for data in try db.prepare(queryTable){
                datas.append(data[JSON])
            }
            
            return datas
        }catch{
            print(error)
        }
        return nil
    }
    //更新数据
    func updateData(userId: Int64, old_name: String, new_name: String) {
        //        let currUser = users.filter(id == userId)
        //        do {
        //            try db.run(currUser.update(name <- name.replace(old_name, with: new_name)))
        //        } catch {
        //            print(error)
        //        }
        
    }
    
    //删除数据
    func delData(userId: Int64) {
        //        let currUser = users.filter(id == userId)
        //        do {
        //            try db.run(currUser.delete())
        //        } catch {
        //            print(error)
        //        }
    }
}


