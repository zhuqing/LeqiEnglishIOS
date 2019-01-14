//
//  WordScentenseDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordScentenseDataCache: DataCache<[WordAndSegment]> {
    private var word:Word
    
    let TYPE = "WordScentenseDataCache"
    let DATA_TYPE = "WordScentenseDataCache_DATE_TYPE"
    
    init(word:Word) {
        self.word = word
    }
    override func getFromCache() -> [WordAndSegment]? {
         let entity = self.word
        guard let datas = SQLiteManager.instance.readData(type: DATA_TYPE, parentId: entity.id ?? "") else{
            return nil
        }
        
        if(datas.isEmpty){
            return nil
        }
        
        var sentences = [WordAndSegment]()
        
        for data in datas{
            sentences.append(WordAndSegment(data: String.toDictionary(data)!))
        }
        return sentences
        
    }
    
    override func cacheData(data: [WordAndSegment]?) {
          let entity = self.word
        guard let dataArr = data else{
            return
        }
        for d in dataArr{
            SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: entity.id ?? "", type: DATA_TYPE)
        }
    }
    
    override func claerData() {
        super.claerData()
        let entity = self.word
        SQLiteManager.instance.delete(type: TYPE, parentId: entity.id ?? "")
    }
    override func getFromService(finished: @escaping ([WordAndSegment]?) -> ()) {
        
        Service.get(path: "/english/wordandsegment/findByWordId?wordId=\(self.word.id!)"){
            (resutls) in
            guard let datas = Service.getDatas(data: resutls) else {
                return
            }
            var wordAndSegments = [WordAndSegment]()
            
            for data in datas{
                wordAndSegments.append(WordAndSegment(data:data))
            }
            
            finished(wordAndSegments)
        }
    }
}
