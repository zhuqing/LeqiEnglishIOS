//
//  ShortWordsInSegmentDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class ShortWordsInSegmentDataCache: DataCache<[ShortWord]> {

    let TYPE = "ShortWordsInSegmentDataCache"
    let DATE_TYPE = "ShortWordsInSegmentDataCache_DATE_TYPE"
    
    private var entity:Segment
    
    init(entity:Segment) {
        self.entity = entity
    }
    
    override func getUpdateTimeType() -> String? {
        return DATE_TYPE
    }
    
    override func getFromCache() -> [ShortWord]? {
        guard let datas = SQLiteManager.instance.readData(type: TYPE, parentId: entity.id ?? "") else{
            return nil
        }
        
        if(datas.isEmpty){
            return nil
        }
        
        var sentences = [ShortWord]()
        
        for data in datas{
            sentences.append(ShortWord(data: String.toDictionary(data)!))
        }
        return sentences
        
    }
    
    override func cacheData(data: [ShortWord]?) {
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
    
    override func getFromService(finished: @escaping ([ShortWord]?) -> ()) {
        Service.get(path: "/shortWord/findBySegmentId?segmentId=\(entity.id ?? "")"){
            (datas) in
            var sentences = [ShortWord]()
            guard let dataArr =  Service.getDatas(data: datas) else{
                finished(sentences)
                return
            }
            
            
            
            for data in dataArr{
                sentences.append(ShortWord(data: data))
            }
            finished(sentences)
        }
    }
}
