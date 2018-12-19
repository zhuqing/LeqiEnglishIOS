//
//  WordContentDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

//没有加载缓存
class WordContentDataCache: DataCache<[Word]> {
    var content:Content
    
    init(content:Content){
        self.content = content
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        Service.get(path: "english/word/findByContentId?contentId=\(self.content.id!)"){(datas) in
            
            let wordDatas = Service.getDatas(data: datas)
            var words = [Word]()
            
            for  data in wordDatas! {
                let word = Word(data:data)
                words.append(word)
            }
            
            finished(words)
            
        }
    }
}
