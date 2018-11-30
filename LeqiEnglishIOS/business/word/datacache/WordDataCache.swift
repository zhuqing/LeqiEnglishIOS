//
//  WordDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/2.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class WordDataCache:DataCache<Word>{
    static let TYPE = "WORD"
       let LOG = LOGGER("WordDataCache")
    private var word:String
    
    init(word:String){
        self.word = word
    }
    
    override func getFromService(finished: @escaping (Word?) -> ()) {
        Service.get(path: "english/word/findByWord?word=\(word)"){
            (resutls) in
            print(resutls)
            guard let data = Service.getData(data: resutls) else {
                return
            }
            finished(Word(data:data))
        }
    }
    
    override func cacheData(data: Word?) {
        guard let d = data else{
            return
        }
        SQLiteManager.instance.insertData(id: d.id ?? "", json: String.toString(d.toDictionary())!,parentId: d.word ?? "", type: WordDataCache.TYPE)
    }
    
    override func getFromCache() -> Word? {
        let dataStr = SQLiteManager.instance.readData(type: WordDataCache.TYPE,parentId:self.word)
        
        guard let arr = dataStr else{
            return nil
        }
        
        if(arr.count == 0){
            return nil
        }
        self.LOG.error("arr.count =\(arr.count )")
        guard let data = String.toDictionary(arr[0]) else{
            return nil
        }
        
        return Word(data: data)
    }
    
    override func isRefresh() -> Bool {
        return false
    }
}
