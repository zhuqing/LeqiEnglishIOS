//
//  MyWords.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyWords: PageDataCache<[Word]> {
    
    private let TYPE = "PageDataCache"
    
    private let LOG = LOGGER("PageDataCache")
  
    static let instance = MyWords()
    
    private override init(){
        
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        guard  let user = UserDataCache.instance.getFromCache() else{
            return
        }
        Service.get(path: "english/word/findByUserId?userId=\(user.id ?? "")&pageSize=\(PAGE_SIZE)"){
            (results) in
            let datas = Service.getDatas(data: results)
           
            guard let array = datas else{
                return
            }
            
            var words = [Word]()
            for data in array{
                let word = Word(data: data)
                words.append(word)
            }
            finished(words)
        }
    }
    
     override func getMoreFromService(page:Int ,  pageSize:Int ,finished: @escaping ([Word]?) -> ()) {
        guard  let user = UserDataCache.instance.getFromCache() else{
            return
        }
        Service.get(path: "english/word/findByUserId?userId=\(user.id ?? "")&\(self.getPageParam(page: page, pageSize: pageSize))"){
            (results) in
            let datas = Service.getDatas(data: results)
            
            guard let array = datas else{
                return
            }
            
            var words = [Word]()
            for data in array{
                let word = Word(data: data)
                words.append(word)
            }
            finished(words)
        }
    }
    
    
    override func getFromCache() -> [Word]? {
        guard let user = UserDataCache.instance.getFromCache() else{
            self.LOG.error("没有加载到用户")
            return nil
        }
        let dataStr =  SQLiteManager.instance.readData(type: TYPE, parentId: user.id ?? "")
        
        guard let arr = dataStr else{
            return nil
        }
        
        if(arr.count == 0){
            return nil
        }
        self.LOG.error("arr.count =\(arr.count )")
        var words = [Word]()
        for d in arr {
            words.append(Word(data: String.toDictionary(d)!))
        }
        
        return words
    }
    
    override func cacheData(data: [Word]?) {
        
   
        
        guard let arr = data else{
            self.LOG.error("数据为nil")
            return
        }
        
        for  d  in arr {
            if(SQLiteManager.instance.readData(id: d.id ?? "" ) != nil){
                continue
            }
            SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: UserDataCache.instance.getUserId(), type: TYPE)
        }
    }
    
    override func claerData() {
        super.claerData()
         SQLiteManager.instance.delete(type: TYPE, parentId: UserDataCache.instance.getUserId())
    }
}
