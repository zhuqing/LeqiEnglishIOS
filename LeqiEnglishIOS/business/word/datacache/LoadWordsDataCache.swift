//
//  LoadWordsDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class LoadWordsDataCache: DataCache<[Word]> {
    
    let LOG = LOGGER("LoadWordsDataCache")
    
    private var path:String
    
     init(path:String) {
        self.path = path
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        Service.get(path: self.path){
            (results) in
            
            guard let datas = Service.getDatas(data: results) else{
                self.LOG.error(self.path)
                return
            }
            
            var words = [Word]()
            
            for data in datas {
                words.append(Word(data: data))
            }
            
            finished(words)
        }
    }
}
