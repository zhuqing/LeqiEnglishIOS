//
//  SentenceInShortWordDataCaches.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class SentenceInShortWordDataCache: DataCache<[Sentence]> {
    let TYPE = "SentenceInShortWordDataCaches"
    let DATE_TYPE = "SentenceInShortWordDataCaches_DATE"
    private var shortWord:ShortWord

    
    init(shortWord:ShortWord){
        self.shortWord = shortWord
    }
    
    override func getUpdateTimeType() -> String? {
        return DATE_TYPE
    }
    
    override func getFromCache() -> [Sentence]? {
        guard let datas = SQLiteManager.instance.readData(type: TYPE, parentId: shortWord.id ?? "") else{
            return nil
        }
        
        if(datas.isEmpty){
            return nil
        }
        
        var sentences = [Sentence]()
        
        for data in datas{
            sentences.append(Sentence(data: String.toDictionary(data)!))
        }
        return sentences
        
    }
    
    override func cacheData(data: [Sentence]?) {
        guard let dataArr = data else{
            return
        }
        for d in dataArr{
            SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: shortWord.id ?? "", type: TYPE)
        }
    }
    
    override func claerData() {
        super.claerData()
        SQLiteManager.instance.delete(type: TYPE, parentId: shortWord.id ?? "")
    }
    
    override func getFromService(finished: @escaping ([Sentence]?) -> ()) {
        Service.get(path: "/sentence/findByShortWordId?shortWordId=\(shortWord.id ?? "")"){
            (datas) in
            var sentences = [Sentence]()
            guard let dataArr =  Service.getDatas(data: datas) else{
                finished(sentences)
                return
            }
            
            
            
            for data in dataArr{
                sentences.append(Sentence(data: data))
            }
            finished(sentences)
        }
    }
    
}
