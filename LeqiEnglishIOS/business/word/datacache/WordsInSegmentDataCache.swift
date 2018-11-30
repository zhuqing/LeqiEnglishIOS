//
//  WordsInSegmentDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class WordsInSegmentDataCache: DataCache<[Word]> {
    let TYPE = "WordsInSegmentDataCache"
    let DATE_TYPE = "WordsInSegmentDataCache_DATE_TYPE"
    
    private var entity:Segment
    
    init(entity:Segment) {
        self.entity = entity
    }
    
    override func getUpdateTimeType() -> String? {
        return DATE_TYPE
    }
    
    override func getFromCache() -> [Word]? {
        guard let datas = SQLiteManager.instance.readData(type: TYPE, parentId: entity.id ?? "") else{
            return nil
        }
        
        if(datas.isEmpty){
            return nil
        }
        
        var sentences = [Word]()
        
        for data in datas{
            sentences.append(Word(data: String.toDictionary(data)!))
        }
        return sentences
        
    }
    
    override func cacheData(data: [Word]?) {
        guard let dataArr = data else{
            return
        }
        for d in dataArr{
            SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: entity.id ?? "", type: TYPE)
        }
    }
    
    override func claerData() {
        super.claerData()
        SQLiteManager.instance.delete(type: TYPE, parentId: entity.id ?? "")
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        Service.get(path: "/english/word/findBySegmentId?segmentId=\(entity.id ?? "")"){
            (datas) in
            var sentences = [Word]()
            guard let dataArr =  Service.getDatas(data: datas) else{
                finished(sentences)
                return
            }
            
            
            
            for data in dataArr{
                sentences.append(Word(data: data))
            }
            finished(sentences)
        }
    }
}
