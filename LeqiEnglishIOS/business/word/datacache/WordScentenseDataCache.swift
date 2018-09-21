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
    
    init(word:Word) {
        self.word = word
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
