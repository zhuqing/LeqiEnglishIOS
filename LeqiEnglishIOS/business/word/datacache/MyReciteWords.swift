//
//  MyReciteWords.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/27.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyReciteWords: DataCache<[Word]> {
    var LOG = LOGGER("MyReciteWords");
    
    static let  instance = MyReciteWords();
    
    private override init() {
        
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        guard  let user = UserDataCache.userDataCache.getFromCache() else{
            self.LOG.error("没有找到user")
            return
        }
        Service.get(path: "english/word/findByUserId?userId=\(user.id ?? "")"){
            (results) in
            let datas = Service.getDatas(data: results)
            
            guard let array = datas else{
                return
            }
            
            var words = [Word]()
            var i = 0
            for data in array{
                i += 1
                let word = Word(data: data)
                words.append(word)
                
                if(i == 5){
                    break
                }
            }
            finished(words)
        }
    }
}
